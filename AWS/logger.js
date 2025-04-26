const winston = require("winston");
require("dotenv");

const transports = [
    new winston.transports.Console()
];

if (process.env.CLOUDWATCH_ENABLED === '1') {
    require("winston-cloudwatch");

    const cloudwatchConfig = {
        logGroupName: "backend-logs",
        logStreamName: `server-instance`,
        awsRegion: "us-west-1",
        jsonMessage: true,
    };

    transports.push(new winston.transports.CloudWatch(cloudwatchConfig));
}

const logger = winston.createLogger({
    transports: transports
});

module.exports = logger;