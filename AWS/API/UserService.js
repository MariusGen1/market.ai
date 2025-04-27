const express = require('express');
const db = require('../Database/db');
const router = express.Router();
const { spawn } = require('child_process');
const logger = require('../logger');

router.post('/createUser', async (req,res,next) => {
    const { uid, financial_literacy_level, stocks } = req.body;
    if (!uid) return res.status(400).send('Missing uid');
    if (financial_literacy_level === null) return res.status(400).send('Missing financial_literacy_server');
    if (!stocks) return res.status(400).send('Missing stocks');  

    try {
        const existing_user = await db.getOne('SELECT uid FROM users WHERE uid = ?', [uid]);
        if (existing_user) return res.status(400).send('User already exists');

        await db.insert('INSERT INTO users (uid, financial_literacy_level) VALUES (?,?)', [uid, financial_literacy_level]);

        for (let i=0; i<stocks.length; i++) {
            const stock = stocks[i];
            let existing_ticker =  await db.getOne('SELECT ticker FROM stocks WHERE ticker = ?', [stock.ticker]);
            if (!existing_ticker) await db.insert('INSERT INTO tickers (symbol, name, market_cap, icon_url) VALUES (?)', [stock.ticker, stock.name, stock.market_cap, stock.icon_url]);

            await db.insert('INSERT INTO portfolio_contents (uid, stock_ticker) VALUES (?,?)', [req.user.uid, stock.ticker]);
        }
       
        let error = '';
        const process = spawn('python3', ['launch-user-agent.py', uid]);
        py.stderr.on('data', (data) => { error += data.toString(); });

        process.on('close', (code) => {
            if (code === 0) return res.status(200).send('Success');
            else {
                logger.error(error);
                return res.status(500).send('Failed to create personal agent');
            }
        });

    } catch(e) { next(e); }
});

router.post('/updatePortfolio', async (req,res,next) => {
    const { stocks } = req.body;
    if (!stocks) return res.status(400).json({ error: 'Tickers are required' });

    try {
        await db.do('DELETE FROM portfolio_contents WHERE uid = ?', [uid]);

        for (let i=0; i<stocks.length; i++) {
            const stock = stocks[i];
            let existing_ticker =  await db.getOne('SELECT ticker FROM stocks WHERE ticker = ?', [stock.ticker]);
            if (!existing_ticker) await db.insert('INSERT INTO tickers (symbol, name, market_cap, icon_url) VALUES (?)', [stock.ticker, stock.name, stock.market_cap, stock.icon_url]);

            await db.insert('INSERT INTO portfolio_contents (uid, stock_ticker) VALUES (?,?)', [req.user.uid, stock.ticker]);
        }

        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

router.post('/fcmToken', async (req,res,next) => {
    const { fcm_token } = req.body;
    if (!fcm_token) return res.status(400).send('Missing fcm_token');

    try {
        await db.do('UPDATE users SET fcm_token = ? WHERE uid = ?', [fcm_token, req.user.uid]);
        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

router.get('/portfolio', async (req,res,next) => {
    try {
        const data = await db.do(`
        SELECT s.*
        FROM portfolio_contents pc
        INNER JOIN stocks s ON pc.stock_ticker = s.ticker
        WHERE pc.uid = ?
        ORDER BY s.market_cap DESC
        `, [req.user.uid]);

        console.log(data);

        return res.status(200).send(data);

    } catch(e) { next(e); }
});

router.get('/allUsers', async (req,res,next) => {
    try {
        const data = await db.do('SELECT uid FROM users');
        return res.status(200).send(data);

    } catch(e) { next(e); }
});

router.get('/userInfo', async (req,res,next) => {
    const { uid } = req.query;

    try {
        const portfolio = await db.do('SELECT s.* FROM portfolio_contents pc INNER JOIN stocks s ON pc.stock_ticker = s.ticker WHERE pc.uid = ?', [uid]);
        const financial_literacy_level = await db.getOne('SELECT financial_literacy_level FROM users WHERE uid = ?', [uid]);
        const recent_articles = await db.do('SELECT * FROM articles WHERE uid = ? ORDER BY ts DESC LIMIT 20', [uid])
        
        return res.status(200).send({
            'portfolio': portfolio,
            'financial_literacy_level': financial_literacy_level,
            'recent_articles': recent_articles
        });

    } catch(e) { next(e); }
});

module.exports = router;