import * as functions from "firebase-functions";
import { admin } from "../config/admin";
import { Storage } from "@google-cloud/storage";
import uuidv4 = require("uuid/v4");

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

const EVENT_LOG_BUCKET = "gorani-reader-249509-gorani-reader-event-log";

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
    const storage = new Storage();
    const bucket = storage.bucket(EVENT_LOG_BUCKET);
    const name = `${obj.classId}$${obj.userId}$${obj.type}$${obj.time}$${serverTime}$${uuidv4()}`;
    const file = bucket.file(name);

    const stream = file.createWriteStream({
      resumable: false
    });

    stream.on("error", err => {
      res.sendStatus(500);
    });

    stream.on("finish", () => {
      res.sendStatus(200);
    });
    stream.end(Buffer.from(JSON.stringify(obj)));
  });
