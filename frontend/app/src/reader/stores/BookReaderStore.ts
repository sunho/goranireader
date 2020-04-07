import { observable, action, computed, reaction } from "mobx";
import RootStore from "../../core/stores/RootStore";
import { User, BookyBook, Book } from "../../core/models";
import FirebaseService from "../../core/stores/FirebaseService";
import { autobind } from "core-decorators";
import { LiteEvent } from "../../core/utils/event";
import ReaderRootStore, { ReaderStore } from "./ReaderRootStore";
import { LogPaginatePayload, PaginateWordUnknown } from "../../core/models/Log";

export interface Location {
  chapterId: string;
  sentenceId: string;
}

@autobind
class BookReaderStore implements ReaderStore {
  rootStore: RootStore | null = null;
  book: BookyBook;
  readerRootStore: ReaderRootStore | null = null;
  @observable location: Location = { sentenceId: "", chapterId: "" };

  constructor(book: BookyBook) {
    this.book = book;
  }

  init(readerRootStore: ReaderRootStore) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
    this.location = this.rootStore.userStore.getLocation(this.book.meta.id);
    reaction(
      () => ({
        sentenceId: this.location.sentenceId,
        chapterId: this.location.chapterId
      }),
      res => {
        const { sentenceId, chapterId } = res;
        this.rootStore!.userStore.saveLocation(this.book.meta.id, {
          sentenceId,
          chapterId
        })
          .catch((e: any) => {
            this.rootStore!.alertStore.add(e.meesage, 1000);
          })
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
    const out = this.book.chapters.findIndex(
      x => x.id === this.location.chapterId
    );
    return out === -1 ? 0 : out;
  }

  @computed get atStart() {
    return this.currentChapterIndex === 0;
  }

  @computed get atEnd() {
    return this.currentChapterIndex === this.book.chapters.length - 1;
  }

  @action nextSection() {
    if (this.currentChapterIndex == this.book.chapters.length - 1) return;
    const newChapter = this.book.chapters[this.currentChapterIndex + 1];
    this.location.chapterId = newChapter.id;
    this.location.sentenceId = newChapter.items[0].id;
  }

  @computed get currentSentenceId() {
    return this.location.sentenceId;
  }

  @action setCurrentSentenceId(sid: string) {
    this.location.sentenceId = sid;
  }

  @action prevSection() {
    if (this.currentChapterIndex == 0) return;
    const newChapter = this.book.chapters[this.currentChapterIndex - 1];
    this.location.chapterId = newChapter.id;
    this.location.sentenceId = newChapter.items[newChapter.items.length - 1].id;
  }

  @action paginate(sids: string[], time: number, words: PaginateWordUnknown[]) {
    const payload: LogPaginatePayload = {
      type: "paginate",
      sids: sids,
      time,
      wordUnknowns: words,
      sentenceUnknowns: [],
      bookId: this.book.meta.id,
      chapterId: this.currentChapter.id
    };
    this.rootStore!.logStore.sendSync(payload);
  }

  destroy() {}
}

export default BookReaderStore;
