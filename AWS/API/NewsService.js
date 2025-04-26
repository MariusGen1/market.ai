const express = require('express');
const db = require('../Database/db');
const router = express.Router();

router.get('/articles', async (req,res,next) => {
    try {
        const data = await db.do('SELECT * FROM articles ORDER BY ts DESC LIMIT 50', [req.user.uid]);
        return res.status(200).send(data);

    } catch(e) { next(e); }
});

module.exports = router;