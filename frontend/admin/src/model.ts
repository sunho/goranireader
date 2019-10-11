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
  chapters: string[];
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
  id?: string;
  quizSolved: any;
  username: string;
  bookReads?: StringMap<number>;
  chapterReads?: StringMap<StringMap<number>>;
  bookReadTimes?: StringMap<number>;
  chapterReadTimes?: StringMap<StringMap<number>>;
  bookQuizScores?: StringMap<number>;
  bookQuizSolved?: StringMap<number>;
  chapterQuizSolved?: StringMap<StringMap<number>>;
  bookPerformance?: StringMap<Performance>;
  ymwPerformance?: YmwPerformance;
  activity?: any[];
  unknownWords?: any[];
  unknownSentences?: any[];
}

export interface RecommendBook {
  title: string;
  cover: string;
  eperc: number;
  nperc: number;
  uperc: number;
  struggles: string[];
}

export interface Report {
  name: string;
  link: string;
  time: string;
}

export interface Performance {
  rc: number;
  vc: number;
  score: number;
  wpm: number;
  uperc: number;
}

export interface Point {
  x: string;
  y: number;
}

export interface YmwPerformance {
  rc: Point[];
  vc: Point[];
  score: Point[];
  wpm: Point[];
  uperc: Point[];
}


export const collator = new Intl.Collator(undefined, {numeric: true, sensitivity: 'base'});
