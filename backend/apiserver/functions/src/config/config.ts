// tslint:disable-next-line:no-implicit-dependencies
import dotenv from 'dotenv';

dotenv.config();

const config = {
    SESSION_SECRET: process.env.SESSION_SECRET || 'gorani-reader12345'
};

export default config;