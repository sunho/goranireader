import express from 'express';
import session from 'express-session';
import {initPassport} from "./passport";
import config from "./config/config";
import passport from "passport";

export const app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.use(session({
    secret: config.SESSION_SECRET,
    resave: false,
    saveUninitialized: false
}));
app.use(passport.initialize());
app.use(passport.session());

initPassport();