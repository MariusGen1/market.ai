const express = require('express');
require('dotenv').config();

const rateLimiter = require('./Middleware/RateLimiter');
const requestLogger = require('./Middleware/RequestLogger');
const logger = require('./logger');
const errorHandler = require('./Middleware/ErrorHandler');
const authentication = require('./Middleware/Authentication');

const app = express();
const PORT = process.env.PORT;

const router = express.Router();

const userService = require('./API/UserService');
const newsService = require('./API/NewsService');
const chatService = require('./API/ChatService');

router.use(userService);
router.use(newsService);
router.use(chatService);

app.use(express.json());
app.use(rateLimiter);
app.use(requestLogger);
app.use(authentication);
app.use('/', router);
app.use(errorHandler);

app.listen(PORT, () => {
    logger.info(`Server is running on port ${PORT}`);
});