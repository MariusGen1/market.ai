const db = require("../Database/db");
const logger = require("../logger");

const authentication = async (req, res, next) => {
    const exempted_routes = [
        '/createUser',
        '/articles',
        '/portfolio',
        '/allUsers'
    ];

    const endpoint = req.url.split('?')[0];

    if (exempted_routes.includes(endpoint)) {
        next();
        return;
    }

    let uid;
    if (req.method === 'GET') uid = req.query.uid;
    else if (req.method === 'POST') uid = req.body.uid;
    if (!uid) return res.status(403).send('Unauthenticated');

    req.user = { uid };

    req.user.info = await db.getOne('SELECT * FROM users WHERE uid = ?', [uid]);

    next();
};

module.exports = authentication;