import * as functions from "firebase-functions";
import { admin } from "../config/admin";
import uuidv4 = require("uuid/v4");

import * as AWS from 'aws-sdk';
AWS.config.loadFromPath('./awscred.json');

function ISODateString(d: Date) {
  function pad(n: number) {
    return n < 10 ? "0" + n : n;
  }
  return (
    d.getUTCFullYear() +
    "-" +
    pad(d.getUTCMonth() + 1) +
    "-" +
    pad(d.getUTCDate()) +
    "T" +
    pad(d.getUTCHours()) +
    ":" +
    pad(d.getUTCMinutes()) +
    ":" +
    pad(d.getUTCSeconds()) +
    "Z"
  );
}

const EVENT_LOG_BUCKET = "gorani-reader-client-event-logs";

export default functions
  .region("asia-northeast1")
  .https.onRequest(async (req, res) => {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Headers', 'Authorization, Content-Type');
    if (req.method === 'OPTIONS') {
      res.sendStatus(200);
      return;
    }
    const item: any = req.body;
    const token = req.headers.authorization;
    const serverTime = ISODateString(new Date());
    const user = await admin.auth().verifyIdToken(token!);
    const res2 = await admin.firestore().collection("users").where("fireId", "==", user.uid).get();
    if (res2.size === 0) {
      res.sendStatus(400);
      return;
    }
    const user2 = res2.docs[0];
    const obj = {
      userId: user2.id,
      fireId: user.uid,
      classId: user2.data()!.classId,
      serverTime: serverTime,
      time: item.time,
      type: item.type,
      payload: item.payload
    };
    const s3 = new AWS.S3();
    const buf = Buffer.from(JSON.stringify(obj));
    const name = `${obj.classId}$${obj.userId}$${obj.type}$${obj.time}$${serverTime}$${uuidv4()}`;
    
    await s3.putObject({
      Bucket: EVENT_LOG_BUCKET,
      Key: name,
      ContentType:'binary/octet-stream',
      Body: buf
    }).promise()

    res.sendStatus(200);
  });
