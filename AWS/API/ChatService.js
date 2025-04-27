const express = require('express');
const db = require('../Database/db');
const router = express.Router();
require('dotenv').config({ path: '../.env' });

router.get('/articleMessages', async (req,res,next) => {
    const { article_id } = req.query;
    if (!article_id) return res.status(400).send('Missing article_id');

    try {
        const data = await db.do('SELECT * FROM article_messages WHERE article_id = ? ORDER BY ts ASC', [article_id]);
        return res.status(200).send(data);

    } catch(e) { next(e); }
});

router.post('/articleMessage', async (req,res,next) => {
    const { article_id, body } = req.body;
    if (!article_id) return res.status(400).send('Missing article_id');
    if (!body) return res.status(400).send('Missing body');

    try {
        const article = await db.getOne('SELECT * FROM articles WHERE article_id = ?', [article_id]);
        const portfolio = await db.do('SELECT stock_ticker FROM portfolio_contents WHERE uid = ?', [req.user.uid]);
        const tickers = portfolio.map(s => s.stock_ticker).join(', ');
        await db.do('INSERT INTO article_messages (article_id, body, is_user_message) VALUES (?,?,?)', [article_id, body, 1]);

        const all_messages = await db.do('SELECT body AS content, CASE WHEN is_user_message=1 THEN "user" ELSE "assistant" END AS role FROM article_messages WHERE article_id = ? ORDER BY ts ASC', [article_id]);

        all_messages.unshift({
            role:    'system',
            content: `You are an assistant helping a user to understand a news article. You should give them answers to the followup questions they are asking you. Make sure to be concise, and STAY ON TOPIC. Do not mention anything about your role. The article title is ${article.title}. Here it is: ${article.body} || Here is the expected impact of the event on the user's financial portfolio: ${article.portfolio_impact} || The user's portfolio is comprised of the assets with tickers ${tickers}. Assume that they are all equally weighted.`
        });

        const req_body = {
            "model": "asi1-mini",
            "messages": all_messages,
            "temperature": 0.8,
            "stream": false,
            "max_tokens": 1024
        };
        
        const response =await fetch("https://api.asi1.ai/v1/chat/completions", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${process.env.ASI1_KEY}`,
                "Content-Type": "application/json"
            },
            body: JSON.stringify(req_body)
        });

        if (!response.ok) {
            const errText = await response.text();
            return res.status(502).send(`AI API error: ${errText}`);
        }

        const completion = await response.json();
        const ai_response = completion.choices[0].message.content;
        await db.insert('INSERT INTO article_messages (article_id, body, is_user_message) VALUES (?,?,?)', [article_id, ai_response, 0]);

        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

module.exports = router;