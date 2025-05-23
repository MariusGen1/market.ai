const { rateLimit } = require('express-rate-limit');

const rateLimiter = rateLimit({
	windowMs: 60 * 1000,
	limit: 200,
	standardHeaders: 'draft-7',
	legacyHeaders: false,
});

module.exports = rateLimiter;