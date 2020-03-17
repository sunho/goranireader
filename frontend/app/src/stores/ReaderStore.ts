import { observable, action } from "mobx";
import RootStore from './RootStore';
import { User, BookyBook, Book } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";

export interface LookUp {
  id: string;
  msg: string;
  duration: number;
}

export interface Location {
  chapterId: string;
  sentenceId: string;
}

@autobind
class ReaderStore {
  private i: number = 0;
  rootStore: RootStore;
  book: BookyBook;
  @observable location: Location | undefined = undefined;
  @observable lookUp: LookUp | undefined = undefined;

  constructor(rootStore: RootStore, book: BookyBook) {
    this.rootStore = rootStore;
    this.book = book;
  }
}

export default ReaderStore;
