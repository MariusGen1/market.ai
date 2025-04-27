const db = require("../Database/db");
const logger = require("../logger");

const authentication = async (req, res, next) => {
    const exempted_routes = [
        '/createUser',
        '/allUsers',
        '/unformattedArticle',
        '/unformattedArticles'
    ];

    const endpoint = req.url.split('?')[0];

    if (exempted_routes.includes(endpoint)) {
        next();
        return;
    }

    console.log(req.query);

    let uid;
    if (req.method === 'GET') uid = req.query.uid;
    else if (req.method === 'POST') uid = req.body.uid;
    if (!uid) return res.status(403).send('Unauthenticated');

    req.user = { uid };

    next();
};

module.exports = authentication;