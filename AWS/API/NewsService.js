const express = require('express');
const db = require('../Database/db');
const router = express.Router();

router.get('/articles', async (req,res,next) => {
    try {
        const data = await db.do('SELECT * FROM articles ORDER BY ts DESC LIMIT 50', [req.user.uid]);
        return res.status(200).send(data);

    } catch(e) { next(e); }
});

router.post('/article', async (req,res,next) => {
    const { title, body, image_url, sources, importance_level, uid, summary, portfolio_impact } = req.body;
    if (!title) return res.status(400).send('Missing title');
    if (!body) return res.status(400).send('Missing body');
    if (!image_url) return res.status(400).send('Missing image_url');
    if (!sources) return res.status(400).send('Missing sources');
    if (importance_level === undefined) return res.status(400).send('Missing importance_level');
    if (!uid) return res.status(400).send('Missing uid');
    if (!summary) return res.status(400).send('Missing summary');
    if (!portfolio_impact) return res.status(400).send('Missing portfolio_impact');

    try {
        await db.insert('INSERT INTO articles (title, body, image_url, sources, importance_level, summary, uid, portfolio_impact) VALUES (?,?,?,?,?,?,?,?)', [title, body, image_url, sources, importance_level, summary, uid, portfolio_impact]);
        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

router.post('/unformattedArticle', async (req,res,next) => {
    const { data } = req.body;
    if (!data) return res.status(400).send('Missing data');

    try {
        await db.do('INSERT INTO unformatted_articles (data) VALUES (?)', [JSON.stringify(data)]);
        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

router.get('/unformattedArticles', async (req,res,next) => {
    try {
        const data = await db.do('SELECT data FROM unformatted_articles WHERE processed = 0 ORDER BY ts DESC');
        res.status(200).send(data.map(a => a.data));
        await db.do('UPDATE unformatted_articles SET processed = 1');

    } catch(e) { next(e); }
});

module.exports = router;