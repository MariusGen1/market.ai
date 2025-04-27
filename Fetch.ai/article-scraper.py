from uagents import Agent, Context
from uagents import Model
from typing import Optional
import aiohttp
from bs4 import BeautifulSoup

class ArticleMessage(Model):
    url: str
    title: Optional[str]
    source: Optional[str]
    published_at: Optional[str]
    html: Optional[str] = None

agent = Agent()

@agent.on_message(model=ArticleMessage)
async def handle_article(ctx: Context, sender: str, msg: ArticleMessage):
    html = ""

    try:
        async with aiohttp.ClientSession() as session:
            async with session.get(msg.url, headers={"User-Agent": "FetchAgent/1.0"}) as resp:
                html = await resp.text()

        soup = BeautifulSoup(html, "html.parser")
        for tag in soup(["script", "style"]):
            tag.decompose()

        for ad in soup.select(".promo, .subscription, .newsletter-signup"):
            ad.decompose()

        clean_text = "\n".join(line.strip() for line in soup.stripped_strings if line.strip() and len(line.strip()) > 0)

        msg.html = clean_text
        await ctx.send("agent1qvvaeyy4vn86rvy88v0xu7a2z4eh6y7gj2a3zuk8k0axr8yr99arv9fesxl", msg)

    except Exception as e:
        ctx.logger.error(f"Error fetching {msg.url}: {e}")

if __name__ == "__main__":
    agent.run()
