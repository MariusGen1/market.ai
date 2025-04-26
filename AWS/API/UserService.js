const express = require('express');
const db = require('../Database/db');
const router = express.Router();

router.post('/createUser', async (req,res,next) => {
    const { uid, financial_literacy_level } = req.body;

    try {
        await db.insert('INSERT INTO users (uid, financial_literacy_level) VALUES (?,?)', [uid, financial_literacy_level]);
        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

router.post('/updatePortfolio', async (req,res,next) => {
    const { tickers } = req.body;
    if (!tickers) return res.status(400).json({ error: 'Tickers are required' });

    try {
        await db.do('DELETE FROM portfolio_contents WHERE uid = ?', [uid]);

        for (let i=0; i<tickers.length; i++) {
            const ticker = tickers[i];
            let existing_ticker =  await db.getOne('SELECT ticker_id FROM tickers WHERE symbol = ?', [ticker.symbol]);
            let ticker_id;

            if (!existing_ticker) ticker_id = await db.insert('INSERT INTO tickers (symbol, name, icon_url, market_cap) VALUES (?)', [ticker.symbol, ticker.name, ticker.icon_url, ticker.market_cap]);
            else ticker_id = existing_ticker.ticker_id;

            await db.insert('INSERT INTO portfolio_contents (uid, ticker_id) VALUES (?,?)', [req.user.uid, ticker_id]);
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
        SELECT t.*
        FROM portfolio_contents pc
        INNER JOIN tickers t ON pc.ticker_id = t.ticker_id
        WHERE pc.uid = ?
        ORDER BY added_ts ASC
        `, [req.user.uid]);

        return res.status(200).send(data);

    } catch(e) { next(e); }
});

module.exports = router;