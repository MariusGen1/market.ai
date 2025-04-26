const mysql = require('mysql2');
require('dotenv').config({ path: '../.env' });

const db = mysql.createPool({
    connectionLimit: 10,
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    multipleStatements: false
});

db.do = (query, values) => {
    return new Promise((resolve, reject) => {
        db.query(query, values, (err, results) => {
            if (err) return reject(err);
            else resolve(results);
        })
    });
}

db.getOne = async (query, values) => {
    const d = await db.do(query, values);
    if (d.length === 1) return d[0];
    return null;
}

db.insert = async (query, values) => {
    return (await db.do(query, values)).insertId;
}

module.exports = db;