import {Sequelize} from 'sequelize';
import config from "../config/config";

const db = new Sequelize(
    config.DATABASE,
    config.DB_USERNAME,
    config.DB_PASSWORD,
    {
        logging: false,
        host: config.DB_HOST,
        port: config.DB_PORT,
        dialect: 'mysql',
        timezone: '+09:00'
    }
);

db.sync();

export default db;
