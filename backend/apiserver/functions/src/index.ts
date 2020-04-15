import express from 'express';
import {initPassport} from "./passport";

export const app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

initPassport();