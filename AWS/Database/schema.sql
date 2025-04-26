DROP DATABASE IF EXISTS market_ai_db;
CREATE DATABASE market_ai_db;
USE market_ai_db;

CREATE TABLE users (
    uid VARCHAR(255) PRIMARY KEY,
    fcm_token VARCHAR(255) NULL,
    financial_literacy_level INT NOT NULL,
    agent_seed VARCHAR(255) NULL
);

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
    body TEXT NOT NULL,
    image_url VARCHAR(300) NOT NULL,
    sources VARCHAR(1500) NOT NULL,
    ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    importance_level INT NOT NULL,
    uid VARCHAR(255) NOT NULL REFERENCES users(uid) ON DELETE CASCADE
);
