import * as functions from 'firebase-functions';
import mod = require('firebase-admin');
mod.initializeApp(functions.config().firebase);
export const admin = mod;
export const db = admin.firestore();