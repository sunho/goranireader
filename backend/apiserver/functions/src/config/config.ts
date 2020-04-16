// tslint:disable-next-line:no-implicit-dependencies
import dotenv from 'dotenv';

dotenv.config();

const config = {
    SESSION_SECRET: process.env.SESSION_SECRET || 'gorani-reader12345',
    DATABASE: process.env.DATABASE || 'gorani',
    DB_USERNAME: process.env.DB_USERNAME || 'username',
    DB_PASSWORD: process.env.DB_PASSWORD || 'password',
    DB_HOST: process.env.DB_HOST || '127.0.0.1',
    DB_PORT: parseInt(process.env.DB_PORT || '3306', 10),

    auth: {
        google: {
            clientID: process.env.GOOGLE_CLIENTID || 'clientID',
            clientSecret: process.env.GOOGLE_CLIENTSECRET || 'clientSecret'
        },
        naver: {
            clientID: process.env.NAVER_CLIENTID || 'clientID',
            clientSecret: process.env.NAVER_CLIENTSECRET || 'clientSecret'
        }
    }
};

export default config;