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
    const { title, body, image_url, sources, importance_level } = req.body;
    if (!title) return res.status(400).send('Missing title');
    if (!body) return res.status(400).send('Missing body');
    if (!image_url) return res.status(400).send('Missing image_url');
    if (!sources) return res.status(400).send('Missing sources');
    if (importance_level === undefined) return res.status(400).send('Missing importance_level');

    try {
        await db.insert('INSERT INTO articles (title, body, image_url, sources, importance_level) VALUES (?,?,?,?,?)', [title, body, image_url, sources, importance_level]);
        return res.status(200).send('Success');

    } catch(e) { next(e); }
});

module.exports = router;