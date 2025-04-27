DROP DATABASE IF EXISTS market_ai_db;
CREATE DATABASE market_ai_db;
USE market_ai_db;

CREATE TABLE users (
    uid VARCHAR(255) PRIMARY KEY,
    fcm_token VARCHAR(255) NULL,
    financial_literacy_level INT NOT NULL,
    agent_seed VARCHAR(255) NULL,
    at_a_glance_text TEXT NULL
);

INSERT INTO users (uid, financial_literacy_level) VALUES ("abcd", 2);

CREATE TABLE stocks (
    ticker VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    market_cap INT NOT NULL,
    icon_url VARCHAR(300) NULL
);

CREATE TABLE portfolio_contents (
    portfolio_contents_id INT PRIMARY KEY AUTO_INCREMENT,
    uid VARCHAR(255) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    stock_ticker INT NOT NULL REFERENCES stocks(ticker) ON DELETE CASCADE,
    added_ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE articles (
    article_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(300) NOT NULL,
    summary TEXT NOT NULL,
    body TEXT NOT NULL,
    portfolio_impact TEXT NOT NULL,
    image_url VARCHAR(300) NOT NULL,
    sources VARCHAR(1500) NOT NULL,
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    importance_level INT NOT NULL,
    uid VARCHAR(255) NOT NULL REFERENCES users(uid) ON DELETE CASCADE
);

INSERT INTO articles (
    title,
    body,
    image_url,
    sources,
    importance_level,
    uid
) VALUES
(
    'S&P 500 Recovers After Historic Volatility Amid Tariff Fears',
    'The S&P 500 staged a dramatic recovery this week, clawing back half of its losses from a sharp decline triggered by renewed tariff threats. Investors have faced one of the most volatile months in recent history, as concerns over escalating trade tensions between the U.S. and China sent shockwaves through global markets. Analysts say further progress will depend on clarity from policymakers and signs of easing rhetoric from both sides. Despite the rebound, market watchers caution that continued volatility could present risks for overbought stocks in the weeks ahead.',
    'https://image.cnbcfm.com/api/v1/image/stock-market-volatility.jpg',
    'CNBC, "S&P 500 recovers half of its tariff decline. What it will take to make it all the way back" (2025-04-26); CNBC, "These four stocks just entered overbought territory and could be due for a drop if volatility persists" (2025-04-26)',
    5,
    'user123'
),
(
    'Americans Turn to ''Buy Now, Pay Later'' for Groceries as Economic Concerns Mount',
    'A growing number of Americans are using "buy now, pay later" (BNPL) services to purchase everyday essentials, including groceries, according to a new survey. The trend highlights rising economic anxiety, with more consumers struggling to cover basic expenses amid persistent inflation and uncertain job prospects. Notably, the survey found a rise in late payments on these short-term loans, raising concerns among financial experts about household debt and the long-term sustainability of BNPL usage for necessities.',
    'https://image.abcnews.com/api/v1/image/bnpl-groceries.jpg',
    'CNBC, "More Americans are financing groceries with buy now, pay later loans - and more are paying those bills late, survey says" (2025-04-26); WSJ, "Americans Are Downbeat on the Economy. They Keep Spending Anyway." (2025-04-26)',
    4,
    'user123'
),
(
    'Tesla Profits Plunge 71% as Anti-Musk Sentiment Hits Sales',
    'Tesla reported a staggering 71% drop in first-quarter profits, missing Wall Street expectations and sending shares lower in after-hours trading. The electric vehicle maker has faced mounting backlash tied to CEO Elon Musk''s political activities, which have sparked protests and calls for boycotts at dealerships worldwide. Analysts say the company’s challenges are compounded by intensifying competition in the EV market and ongoing supply chain disruptions. Tesla’s leadership has pledged to address consumer concerns and stabilize operations in the coming months.',
    'https://image.abcnews.com/api/v1/image/tesla-profits-drop.jpg',
    'ABC News, "Tesla profits drop 71% amid anti-Musk backlash" (2025-04-22); CNBC, "Amazon and Nvidia say all options are on the table to power AI including fossil fuels" (2025-04-26)',
    5,
    'user123'
);

CREATE TABLE unformatted_articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data JSON NOT NULL,
    processed BOOLEAN NOT NULL DEFAULT 0,
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE article_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT NOT NULL REFERENCES articles(article_id) ON DELETE CASCADE,
    body TEXT NOT NULL,
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_user_message BOOLEAN NOT NULL
);