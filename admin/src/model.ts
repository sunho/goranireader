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

export interface UserInsight {
  username: string;
  clientBookRead: Map<string, number>;
}
