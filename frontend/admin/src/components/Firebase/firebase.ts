import app from "firebase/app";
import "firebase/auth";
import "firebase/database";
import "firebase/firestore";
import { makeCode } from "../../secret";

const config = {
  apiKey: process.env.REACT_APP_API_KEY,
  authDomain: process.env.REACT_APP_AUTH_DOMAIN,
  databaseURL: process.env.REACT_APP_DATABASE_URL,
  projectId: process.env.REACT_APP_PROJECT_ID,
  storageBucket: process.env.REACT_APP_STORAGE_BUCKET,
  messagingSenderId: process.env.REACT_APP_MESSAGING_SENDER_ID
};

class Firebase {
  db: firebase.firestore.Firestore;
  auth: firebase.auth.Auth;
  emailAuthProvider: any;
  serverValue: any;
  constructor() {
    app.initializeApp(config);

    /* Helper */

    this.serverValue = app.database.ServerValue;
    this.emailAuthProvider = app.auth.EmailAuthProvider;

    /* Firebase APIs */

    this.auth = app.auth();
    this.db = app.firestore();
  }

  // *** Auth API ***

  doCreateUserWithEmailAndPassword = (email: string, password: string) =>
    this.auth.createUserWithEmailAndPassword(email, password);

  doSignInWithEmailAndPassword = (email: string, password: string) =>
    this.auth.signInWithEmailAndPassword(email, password);

  doSignOut = () => this.auth.signOut();

  doPasswordReset = (email: string) => this.auth.sendPasswordResetEmail(email);

  doPasswordUpdate = (password: string) =>
    this.auth.currentUser!.updatePassword(password);

  onAuthUserListener = (next: any, fallback: any) =>
    this.auth.onAuthStateChanged(authUser => {
      if (authUser) {
        this.user(authUser.uid)
          .get()
          .then(doc => {
            if (doc.exists) {
              const dbUser = doc.data();
              next({
                uid: authUser!.uid,
                email: authUser!.email,
                ...dbUser
              });
            } else {
              next(authUser);
            }
          })
          .catch(err => {
            console.error(err);
            next(authUser);
          });
      } else {
        fallback();
      }
    });

  user = (uid: string) => this.db.collection("users").doc(uid);
  users = () => this.db.collection("users");
  books = () => this.db.collection("books");
  dataResult = (id: string) => this.db.collection("dataResult").doc(id);
  clientComputed = (id: string) => this.dataResult(id).collection("clientComputed");
  reports = (id: string) => this.dataResult(id).collection("reports");
  serverComputed = (id: string) => this.dataResult(id).collection("serverComputed");
  recommendedBooks = (id: string) => this.dataResult(id).collection("recommendedBooks");
  clas = (id: string) => this.db.collection("classes").doc(id);

  generateSecretCode = async () => {
    let code = ""
    while(true) {
      code = makeCode();
      const doc = await this.db.collection("secretCodes").doc(code).get();
      if (!doc.exists) {
        break;
      }
    }
    await this.db.collection("secretCodes").doc(code).set({});
    return code;
  };
}

export default Firebase;
