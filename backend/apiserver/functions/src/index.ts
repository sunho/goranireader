import express from 'express';
import session from 'express-session';
import {initPassport} from "./passport";
import config from "./config/config";
import passport from "passport";
import log4js from 'log4js';
import logconfig from './log4js.json';

export const app = express();
export const logger = log4js.getLogger();

log4js.configure(logconfig);

logger.level = 'ALL';

app.use(express.urlencoded({extended: false}));
app.use(express.json());

app.use(session({
    secret: config.SESSION_SECRET,
    resave: false,
    saveUninitialized: false
}));
app.use(passport.initialize());
app.use(passport.session());

initPassport();