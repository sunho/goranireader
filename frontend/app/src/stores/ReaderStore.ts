import { observable, action, computed } from "mobx";
import RootStore from './RootStore';
import { User, BookyBook, Book } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";
import { LiteEvent } from "../utils/event";

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
  rootStore: RootStore;
  book: BookyBook;
  @observable location: Location = {chapterId: '', sentenceId: ''};
  @observable lookUp: LookUp | undefined = undefined;
  onCancel: LiteEvent<void> = new LiteEvent();
  @computed get currentChapter() {
    return this.book.chapters[this.currentChapterIndex];
  }
  @computed get currentChapterIndex() {
    const out = this.book.chapters.findIndex(x => x.id === this.location.chapterId);
    return out === -1 ? 0 : out;
  }

  constructor(rootStore: RootStore, book: BookyBook) {
    this.rootStore = rootStore;
    this.book = book;
  }

  @action nextChapter() {
    if (this.currentChapterIndex  == this.book.chapters.length -1) return;
    const newChapter = this.book.chapters[this.currentChapterIndex + 1];
    this.location.chapterId = newChapter.id;
    this.location.sentenceId = newChapter.items[0].id;
  }

  @action prevChapter() {
    if (this.currentChapterIndex == 0) return;
    const newChapter = this.book.chapters[this.currentChapterIndex - 1];
    this.location.chapterId = newChapter.id;
    this.location.sentenceId = newChapter.items[newChapter.items.length - 1].id;

  }
}

export default ReaderStore;
