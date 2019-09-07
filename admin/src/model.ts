import { firestore } from "firebase";

export interface Class {
  id: string;
  name: string;
  mission?: Mission;
}

export interface Mission {
  id: string;
  bookId?: string;
  message: string;
  due: firestore.Timestamp;
}

export interface AdminUser {
  uid: string;
  email: string;
  admin: boolean;
  classes: string[];
}

interface StringMap<V> {
  [k: string]: V;
}

export interface UserInsight {
  quizSolved: any;
  username: string;
  bookReads?: StringMap<number>;
  chapterReads?: StringMap<StringMap<number>>;
  bookReadTimes?: StringMap<number>;
  chapterReadTimes?: StringMap<StringMap<number>>;
  bookQuizScores?: StringMap<number>;
  bookQuizSolved?: StringMap<number>;
  chapterQuizSolved?: StringMap<StringMap<number>>;
}

export interface Report {
  name: string;
  link: string;
  time: string;
}
