const logger = require("../logger");

const errorHandler = (err, req, res, next) => {  
    req = {
        body: req.body,
        method: req.method,
        url: req.url,
        params: req.params,
        query: req.query,
        rateLimit: req.rateLimit,
        user: req.user,
        rawHeaders: req.rawHeaders
    };

    logger.error({
        message: 'Server Error',
        url: req.url,
        req: req,
        error: err.message,
        stack: err.stack
    });
  
    res.status(500).json('Something went wrong :(');
};

module.exports = errorHandler;