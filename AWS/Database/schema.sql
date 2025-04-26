DROP DATABASE IF EXISTS market_ai_db;
CREATE DATABASE market_ai_db;
USE market_ai_db;

CREATE TABLE users (
    uid VARCHAR(255) PRIMARY KEY,
    fcm_token VARCHAR(255) NULL,
    literacy_level INT NOT NULL
);

CREATE TABLE tickers (
    ticker_id INT PRIMARY KEY AUTO_INCREMENT,
    symbol VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    icon_url VARCHAR(300) NOT NULL,
    market_cap INT NOT NULL
);

CREATE INDEX idx_tickers_symbol ON tickers(symbol);

CREATE TABLE portfolio_contents (
    portfolio_contents_id INT PRIMARY KEY AUTO_INCREMENT,
    uid VARCHAR(255) NOT NULL REFERENCES users(uid) ON DELETE CASCADE,
    ticker_uid INT NOT NULL REFERENCES tickers(ticker_id) ON DELETE CASCADE,
    added_ts DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);