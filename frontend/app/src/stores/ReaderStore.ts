import { observable, action, computed, reaction } from "mobx";
import RootStore from './RootStore';
import { User, BookyBook, Book } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";
import { LiteEvent } from "../utils/event";
import ReaderRootStore from "./ReaderRootStore";
import { LogPaginatePayload, PaginateWordUnknown } from "../models/Log";

export interface Location {
  chapterId: string;
  sentenceId: string;
}

@autobind
class ReaderStore {
  rootStore: RootStore;
  book: BookyBook;
  readerRootStore: ReaderRootStore;
  @observable location: Location;

  constructor(readerRootStore: ReaderRootStore, book: BookyBook) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
    this.book = book;
    this.location = this.rootStore.userStore.getLocation(book.meta.id);
    reaction(
      () => ({sentenceId: this.location.sentenceId, chapterId: this.location.chapterId}),
      (res) => {
        const {sentenceId, chapterId} = res;
        this.rootStore.userStore
          .saveLocation(this.book.meta.id, {sentenceId, chapterId})
          .catch((e: any) => {this.rootStore.alertStore.add(e.meesage, 1000)})
          .then(() => {});
      }
    );
  }

  @computed get sentences() {
    return this.currentChapter.items;
  }
  @computed get currentChapter() {
    return this.book.chapters[this.currentChapterIndex];
  }
  @computed get currentChapterIndex() {
    const out = this.book.chapters.findIndex(x => x.id === this.location.chapterId);
    return out === -1 ? 0 : out;
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

  @action paginate(sids: string[], time: number, words: PaginateWordUnknown[]) {
    const payload: LogPaginatePayload = {
      type: 'paginate',
      sids: sids,
      time,
      wordUnknowns: words,
      sentenceUnknowns: [],
      bookId: this.book.meta.id,
      chapterId: this.currentChapter.id,
    };
    this.rootStore.logStore.send(payload).catch(e => {this.rootStore.alertStore.add(e.message, 1000)}).then(resp => console.log('sent'));
  }
}

export default ReaderStore;
