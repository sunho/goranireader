import express from 'express';

export const app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());