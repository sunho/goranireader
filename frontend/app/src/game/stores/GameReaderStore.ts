import { observable, action, computed, reaction } from "mobx";
import RootStore from '../../core/stores/RootStore';
import { User, BookyBook, Book, Sentence, Item } from "../../core/models";
import FirebaseService from "../../core/stores/FirebaseService";
import { autobind } from "core-decorators";
import { LiteEvent } from "../../core/utils/event";
import ReaderRootStore, { ReaderStore } from "../../reader/stores/ReaderRootStore";
import { LogPaginatePayload, PaginateWordUnknown } from "../../core/models/Log";

export interface Location {
  chapterId: string;
  sentenceId: string;
}

@autobind
class GameReaderStore implements ReaderStore {
  rootStore: RootStore | null = null;
  sentences: Item[];
  readerRootStore: ReaderRootStore | null = null;
  sentenceId: string = '';
  constructor(sentences: Item[]) {
    this.sentences = sentences;
  }

  init(readerRootStore: ReaderRootStore) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
  }


  get atStart() {
    return true;
  }

  get atEnd() {
    return true;
  }

  nextSection() {
  }

  get currentSentenceId() {
    return this.sentenceId;
  }

  setCurrentSentenceId(sid: string) {
    this.sentenceId = sid;
  }

  prevSection() {
  }

  paginate(sids: string[], time: number, words: PaginateWordUnknown[]) {
  //   const payload: LogPaginatePayload = {
  //     type: 'paginate',
  //     sids: sids,
  //     time,
  //     wordUnknowns: words,
  //     sentenceUnknowns: [],
  //     bookId: this.book.meta.id,
  //     chapterId: this.currentChapter.id,
  //   };
  //   this.rootStore!.logStore.send(payload).catch(e => {this.rootStore!.alertStore.add(e.message, 1000)}).then(resp => console.log('sent'));
  }
}

export default GameReaderStore;
