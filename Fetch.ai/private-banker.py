
from uagents import Agent, Context
from uagents import Model
from typing import Optional
import aiohttp
from uagents_core.contrib.protocols.chat import ChatMessage, TextContent
import requests
import json

class ArticleMessage(Model):
    url: str
    title: Optional[str]
    source: Optional[str]
    published_at: Optional[str]
    html: Optional[str] = None

class PrivateBankerInput(Model):
    new_articles: list[ArticleMessage]
    uid: str

agent = Agent()

def articleMessageJson(articleMessage: ArticleMessage) -> str:
    return "\{\"title\":\"" + articleMessage.title + "\"" + "\}"

@agent.on_message(model=PrivateBankerInput)
async def handle_article(ctx: Context, sender: str, inp: PrivateBankerInput):
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://52.52.57.22:3000/userInfo?uid={inp.uid}", headers={"Accept": "application/json"}, timeout=5) as resp:
                user_info = await resp.json()

        system_prompt = """
        You are a personal banker for the user of an app called market.ai. 
        You will not be interacting directly with the user.
        Instead, you are in charge of curating financial news based on the user's portfolio, combining and adapting news articles such that they are as relevant as possible to the user.
        Specifically, you must:
        - Consider all the articles I give you.
        - Group the ones that talk about the same event.
        - Filter to only the ones that are very likely to be relevant to the user's portfolio. This step is very important.
        - Filter to only the ones that the user has not been informed of yet. If this is a new development of an older article, feel free to include it. The user must absolutely not get duplicate articles, or extremely similar ones.
        - Write news articles that are relevant to the user. These should be 100-300 words total, depending on how much information there is. Do not make anything up, but please search the web if you think that's useful.
        - The articles should: cater to the user's level of understanding of finance (explain in more or less complicated terms); include some information on how the user's portfolio will be impacted (there's a JSON field for that, as you can see in the example).
        - Output a LIST OF JSON OBJECTS (this is VERY important!), corresponding to news articles. I will show you the exact format.

        Here is the format for an article (remember, your output should be a list of these - and NOTHING ELSE):
        {
        "title": "# Trump Raises China Tariffs to 145%, Sparking Market Jitters",
        "summary": "Trump has announced 145% tariffs on China. The equity markets have declined sharply as a consequence",
        "body": "President Trump announced early this morning a sweeping increase in U.S. tariffs on Chinese imports, boosting the levy to **145%** across more than 5,000 product categories. The move, intended to close the bilateral trade gap and pressure China on intellectual property issues, represents the steepest tariff hike in U.S. history.\n\nEquity markets reacted sharply: the S&P 500 slipped 1.8% by midday, while the Nasdaq Composite tumbled 2.3%, as investors grappled with the prospect of higher input costs and pronounced supply-chain disruptions. Analysts pointed out that sectors reliant on Chinese manufacturing—consumer electronics, automotive parts, and semiconductors—are likely to see margin compression and delivery delays.\n\n**Tesla (TSLA)** shares fell nearly 3% after trading reopened, amid concerns that steeper levies on imported components from Shanghai and Shenzhen will drive up production costs at the Fremont and Berlin Gigafactories. **Nvidia (NVDA)** dropped 2.5%, as the semiconductor giant’s China-based foundry partners face heavier duties on raw wafers and packaging materials.",
        "portfolio_impact": "Today’s tariff shock could translate into slimmer profit margins and short-term price volatility. You may see Tesla’s manufacturing costs rise by 5–8%, while Nvidia might incur a 3–6% bump in chip production expenses. Consider monitoring earnings guidance and possibly rebalancing to hedge against further trade-policy risks."
        "image_url": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.fox4news.com%2Fnews%2Famericans-talk-trump-tariffs-poll&psig=AOvVaw318sIDSq-cgSoLcmpNbbQ9&ust=1745800053737000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCPi-tJL69owDFQAAAAAdAAAAABAE",
        "importance_level": 80,
        "sources": "https://www.cnn.com/2025/04/26/business/trump-tariffs-small-businesses/index.html,https://thehill.com/homenews/administration/5264148-trump-china-tariffs/"
        }

        Note that you should pick the image URL from the ones in the articles you are summarizing. Use the image from the most relevant article.
        The importance level goes from 0-100, and consider relevance to the user, as well as overall impact and novelty.
        The sources field is a comma-separated list of the URLs of the articles you used to write each article. These should be from the list of articles you are given as input.
        In the article, do not mention your existence. It should seem like a normal news article. Also do not mention what you know about the user's literacy level (take it into account when writing the articles still).
        You must also generate a very brief summary of the article, which will be displayed at the top of the article.
        Remember, it is very possible that it is best to output an empty array.
        Do not include titles in the body or portfolio_impact (for example DON'T prefix the portfolio impact with "Portfolio Impact:").
        DO NOT USE NEWLINES. Instead, you must use \\n (backslash-n) every time you are looking to enter a newline.
        VERY IMPORTANT: Your output is an ARRAY OF JSON OBJECTS like the one above, WITH NO OTHER CONTENT WHATSOEVER. You should not wrap it in a markdown JSON tag.
        You should NOT use ANY MARKDOWN HEADERS/TITLES.
        """

        literacy_level = user_info["financial_literacy_level"]
        # portfolio = ",".join(user_info["portfolio"])
        portfolio = "AAPL,TSLA,BRK.B,GOOGL,NVDA,IONQ,HOOD,JSPR,MSTR,QMCO,QBTS,SPOT"

        recent_articles = "  ||  ".join(
            f"{a['title']} {a['body']}" 
            for a in user_info["recent_articles"]
        )

        new_articles = "  ||  ".join(
            articleMessageJson(a) 
            for a in inp.new_articles
        )

        prompt = f"""
        The user holds the following stocks: {portfolio}. Assume that they hold an equal amount of each. The user's financial literacy level is {literacy_level}.
        Here are the recent articles that have been presented to the user (make sure to not make duplicates of these):
        Here are the latest articles (the ones you should focus on, and present to the user in a summarized and relevant format - excluding irrelevant ones):
        REMEMBER, YOU SHOULD ABSOLUTELY NOT WRAP THE RESPONSE IN BACKTICKS TO INDICATE THAT IT'S JSON. THE RESPONSE SHOULD START WITH A SQUARE BRACKET AND END WITH ONE.
        """

        data = {
            "model": "asi1-mini",
            "messages": [
                {
                    "role": "system",
                    "content": system_prompt
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            "temperature": 0.9,
            "stream": False,
            "max_tokens": 2000
        }

        response = requests.post("https://api.asi1.ai/v1/chat/completions", json=data, headers={
            "Authorization": "bearer sk_6c8be2ce10e84e41898335e067068f9da156f3b49a454fb391ace8889b14a20a"
        })

        response.raise_for_status()
        resp_json = response.json()
        assistant_message = resp_json["choices"][0]["message"]["content"]
        ctx.logger.info(assistant_message)
        ai_articles = json.loads(assistant_message)

        for article in ai_articles:
            async with aiohttp.ClientSession() as session:
                async with session.post("http://52.52.57.22:3000/article", headers={"Accept": "application/json"}, timeout=5, json={
                    "title": article.get("title"),
                    "summary": article.get("summary"),
                    "body": article.get("body"),
                    "portfolio_impact": article.get("portfolio_impact"),
                    "image_url": article.get("image_url"),
                    "sources": article.get("sources"),
                    "importance_level": article.get("importance_level"),
                    "uid": inp.uid
                }) as resp:
                    ctx.logger.info("Done!")
            

    except Exception as e:
        ctx.logger.error(f"An error ocurred: {e}")

if __name__ == "__main__":
    agent.run()