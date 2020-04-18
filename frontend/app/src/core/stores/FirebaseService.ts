import React from "react";
import app from "firebase/app";
import "firebase/auth";
import "firebase/database";
import "firebase/firestore";
import { autobind } from "core-decorators";

const config = {
  apiKey: "AIzaSyDPdHYw3Q5_3oZz-vW6Km57JevsMO9AKyw",
  authDomain: "gorani-reader-249509.firebaseapp.com",
  databaseURL: "https://gorani-reader-249509.firebaseio.com",
  projectId: "gorani-reader-249509",
  storageBucket: "gorani-reader-249509.appspot.com",
  messagingSenderId: "119282460172",
  appId: "1:119282460172:web:961b939ab3a6544fd07029",
  measurementId: "G-KH251583QK"
};

@autobind
class FirebaseService {
  db: firebase.firestore.Firestore;
  auth: firebase.auth.Auth;

  constructor() {
    app.initializeApp(config);
    this.db = app.firestore();
    this.auth = app.auth();
  }

  async init() {
    const { user } = await this.auth.signInAnonymously();
    console.log("logined as " + user!.uid);
    return Promise.resolve();
  }

  fuserDoc() {
    return this.db.collection("fireUsers").doc(this.auth.currentUser!.uid);
  }

  userDoc(id: string) {
    return this.db.collection("users").doc(id);
  }

  books() {
    return this.db.collection("books");
  }

  users() {
    return this.db.collection("users");
  }
}

export default FirebaseService;
