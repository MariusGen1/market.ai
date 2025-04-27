from uagents import Agent, Context
import aiohttp
from datetime import datetime, timezone

API_KEY = '96f0dc70b16d2643a880627a24719b37' # We're disabling this as soon as the hackathon is over 😎
BASE_URL = f'http://api.mediastack.com/v1/news?access_key={API_KEY}&languages=en&limit=10'

class ArticleMessage(Model):
    url: str
    title: Optional[str]
    source: Optional[str]
    published_at: Optional[str]
    html: Optional[str] = None

agent = Agent(name="news-agent")

@agent.on_interval(period=60.0)  # Runs every 60 seconds
async def fetch_news(ctx: Context):
    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(BASE_URL) as response:
                if response.status != 200:
                    ctx.logger.error(f"Failed to fetch news, status code: {response.status}")
                    return
                data = await response.json()
                articles = data.get('data', [])
    except Exception as e:
        ctx.logger.error(f"Error fetching news: {e}")
        return

    # Retrieve the last fetched timestamp from storage
    last_fetched_at_str = ctx.storage.get("last_fetched_at")
    if last_fetched_at_str:
        last_fetched_at = datetime.fromisoformat(last_fetched_at_str)
    else:
        last_fetched_at = None

    new_articles = []
    for article in articles:
        published_str = article.get('published_at')
        if not published_str:
            continue
        try:
            published_at = datetime.fromisoformat(published_str.replace('Z', '+00:00'))
        except ValueError:
            continue

        if not last_fetched_at or published_at > last_fetched_at:
            new_articles.append((published_at, article))

    if new_articles:
        # Sort articles by published time
        new_articles.sort(key=lambda x: x[0])

        for published_at, article in new_articles:
            # ctx.logger.info(f"New Article Found:")
            # ctx.logger.info(f"  Title: {article.get('title')}")
            # ctx.logger.info(f"  Source: {article.get('source')}")
            # ctx.logger.info(f"  Published: {article.get('published_at')}")
            # ctx.logger.info(f"  URL: {article.get('url')}\n")

            await ctx.send("agent1qgwaxpsnpzrh39xapna6svwdqhgzjsnax8ymgt4ds7yh3x4p4nlgyqxmja3", ArticleMessage(
                url=article.get('url'),
                title=article.get('title'),
                source=article.get('source'),
                published_at=article.get('published_at')
            ))

        # Update the last fetched timestamp in storage
        latest_published_at = new_articles[-1][0].isoformat()
        ctx.storage.set("last_fetched_at", latest_published_at)
    else:
        ctx.logger.info("No new articles found.")

if __name__ == "__main__":
    agent.run()
