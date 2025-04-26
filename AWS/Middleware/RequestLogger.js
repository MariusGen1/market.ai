const logger = require("../logger");

const requestLogger = (req, res, next) => {
    const start = Date.now();
    res.on("finish", () => {
        const duration = Date.now() - start;

        logger.info({
            message: 'Endpoint log',
            method: req.method,
            url: req.url,
            response_time: duration
        });
    });
    
    next();
};

module.exports = requestLogger;