from uagents import Agent, Context
from uagents import Model
from typing import Optional
import aiohttp
from uagents_core.contrib.protocols.chat import ChatMessage, TextContent
import requests

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

@agent.on_event("startup")
async def init_storage(ctx: Context):
    ctx.storage.set("articles", [])

@agent.on_interval(period=30.0)  # Runs every 60 seconds
async def dispatch_news(ctx: Context):
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get("http://52.52.57.22:3000/allUsers", headers={"Accept": "application/json"}, timeout=5) as resp:
                users = await resp.json()
        uids = [u["uid"] for u in users if "uid" in u]

        async with aiohttp.ClientSession() as session:
            async with session.get("http://52.52.57.22:3000/unformattedArticles", headers={"Accept": "application/json"}, timeout=5) as resp:
                raw_list = await resp.json()

        parsed = [
            json.loads(item) if isinstance(item, str) else item
            for item in raw_list
        ]

        articles = [
            ArticleMessage(
                url=art.get("url"),
                title=art.get("title"),
                source=art.get("source"),
                published_at=art.get("published_at"),
                html=art.get("html")
            )
            for art in parsed
        ]

        for uid in uids:
            payload = PrivateBankerInput(new_articles=articles, uid=uid)
            await ctx.send("agent1qgv22g3u38sxlkhlkpmrvyndsa2hfqcx7qz5kzlw3cehenhw65ct2saux3s", payload)

    except Exception as e:
        ctx.logger.error(f"(1) An error ocurred: {e}")

@agent.on_message(model=ArticleMessage)
async def handle_article(ctx: Context, sender: str, article: ArticleMessage):
    try:
        prompt = f"I want you to help me assess if this article is complete, or hit a paywall. You should only output either YES or NO. Output YES if you think the article is likely to be complete and makes sense, or NO if it's most likely had some sort of major issue. You should be very generous. Do not expect any perfectly formatted articles. As long as they could be useful, say yes. DO NOT OUTPUT ANYTHING ELSE. Thanks! Here is the article content: {article.html}"

        data = {
            "model": "asi1-mini",
            "messages": [
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            "temperature": 0.4,
            "stream": False,
            "max_tokens": 100
        }

        # response = requests.post("https://api.asi1.ai/v1/chat/completions", json=data, headers={
            # "Authorization": "bearer sk_6c8be2ce10e84e41898335e067068f9da156f3b49a454fb391ace8889b14a20a"
        # })
        # response.raise_for_status()
        # resp_json = response.json()
        # assistant_message = resp_json["choices"][0]["message"]["content"]
        # ctx.logger.info(assistant_message)

        # if assistant_message == "NO":
            # ctx.logger.info('Should be filtered')
            # return
        
        formatted_article = article.model_dump_json()
        async with aiohttp.ClientSession() as session:
            async with session.post("http://52.52.57.22:3000/unformattedArticle", headers={"Accept": "application/json"}, timeout=5, json={"data": formatted_article}) as resp:
                ctx.logger.info("Done!")

    except Exception as e:
        ctx.logger.error(f"(2) An error ocurred: {e}")

if __name__ == "__main__":
    agent.run()
