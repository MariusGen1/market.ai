# market.ai

<img width="750" alt="market-ai-thumbnail" src="https://github.com/user-attachments/assets/40e191ff-6981-4751-977d-a2261ea6bc6d" />

## Inspiration
All of our team members are interested in finance, to varying degrees. After some brainstorming, we quickly found an issue that we all saw value in solving: democratizing access to high quality, relevant, financial news. We're solving three main problems:
- **News saturation:** there's too many outlets to choose from - and oftentimes they're not relevant enough.
- **Knowledge Barrier:** financial news can get tricky, making it hard for the average trader to stay up to date.
- **Lack of Trust:** it's becoming increasingly harder to find reliable news outlets.

These three problems are what led us to building our app, **market.ai**.

## What it does
market.ai is a financial news outlet that solves the three problems we identified:
- **Relevance**: market.ai cherry-picks news that are highly relevant to **your portfolio** 
- **Personalization:** our app adapts the news articles to your level of financial literacy - so you get exactly the information you're looking for.
- **Reliability:** we poll data from **7,500+** sources, filter them for quality and crosscheck them using AI, ensuring you get the most trustworthy news.

And to top it all off - this happens in real-time, so you're always up to date with the latest developments!

With market.ai, everyone gets their own private banker. We'd even argue that it's better than that - when's the last time you saw a banker read, crosscheck, summarize and send you news in less than 30 seconds? 🤓


## How we built it
### Agents
All the heavy lifting in this project is done by fetch.ai agents. We have a grand total of **4** custom uAgents 😎  Put simply, here's how they work and interact: we have a `news-agent` which is responsible for polling for news articles very frequently – and 24/7. As soon as it finds a new article, it sends the link along with some metadata to our `news-scraper` agent. This agent is called for every article, and is responsible for getting data from the link provided, before passing it along to our `aggregation-agent`. In this next step, articles are quality-checked and aggregated over the timespan of a few minutes - enough to gather around 20 or so articles - before finally being dispatched to our `private-banker` agents. This is where the real magic happens: each market.ai user gets their very own personal banker. Whenever news articles are received, their relevance is considered on an individual basis, before crafting custom-made articles tailored to each user. This may sound complicated, but all happens within just a few seconds.

### Backend
To bridge the gap between the agents and our app, we are using an AWS EC2 instance alongside an RDS database running MySQL. These give us affordable top-tier performance with large scaling potential. The EC2 instance is running an Express server, and offers all the endpoints the app needs.

### Frontend
Our app is written in Swift, using the SwiftUI framework. We chose to use SwiftUI to get access to Apple's latest UI components, making for a seamless user experience.

## Challenges we ran into
Our biggest challenge was getting quality news data. Our considerations for picking sources were 1) whether or not they offered access to multiple news outlets or not, and 2) price - with 2 being the largest roadblock. After some research, we settled for **mediastack**, which offers access to **7,500+** sources from all over the world, giving us articles every 10 seconds on average. We were slightly concerned by the sheer amount of data we'd have to process, but it turned out not to be a problem for our agents.

The next challenge was getting all the agents set up. Thankfully, the compartmentalization offered by using agents enabled us to isolate the problems, and solve them one at a time. We definitely spent a few hours setting them up, but once we finished, it worked perfectly.

## Accomplishments that we're proud of

We’re proud of how far our Fetch.ai agents have come in just 36 hours — analyzing news, connecting data, and powering real-time insights behind the scenes. Massive thanks to them – couldn't have made it possible without.

## What we learned

"Hello World" .... just kidding. Learned a ton about multi-agent interactions, developing a pitch deck, working on a team, collaborating on frontend, backend and everything in between. Definitely a steep learning curve for some of our team members with less coding experience, but very fun nonetheless.

## What's next for market.ai
We're hoping to leverage our agent-based architecture to expand the financial capabilities of the app. For expert users, we'd love to add trading strategies to the app, and combine traditional quantitative techniques with news-based information gathering to provide more accurate insights. Another direction we would look into exploring is giving users the ability to manage their portfolio through a chat interface - once again, using agents.
