import { observable, action, computed, reaction } from "mobx";
import RootStore from './RootStore';
import { User, BookyBook, Book } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";
import { LiteEvent } from "../utils/event";
import ReaderRootStore from "./ReaderRootStore";
import ReaderStore from "./ReaderStore";
import { PaginateWordUnknown } from "../models/Log";

export interface LookUp {
  id: string;
  msg: string;
  duration: number;
}

@autobind
class ReaderUIStore {
  readerRootStore: ReaderRootStore;
  rootStore: RootStore;

  @observable lookUp: LookUp | undefined = undefined;
  @observable cutted: Boolean = false;
  @observable loaded: Boolean = false;
  @observable dividePositions: number[] = [];
  @observable fontSize: number = 20;
  timer: ReturnType<typeof setInterval> = 0;

  onCancelSelection: LiteEvent<void> = new LiteEvent();
  readerStore: ReaderStore;

  currentTime: number = 0;
  unknownWords: PaginateWordUnknown[] = [];

  constructor(readerRootStore: ReaderRootStore) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
    this.readerStore = readerRootStore.readerStore;
    window.addEventListener('focus', this.startTimer);
    window.addEventListener('blur', this.stopTimer);
    reaction(() => this.cutted, cutted => {
      if (cutted) {
        this.currentTime = 0;
      }
    });
  }

  timerHandler() {
    this.currentTime+=10;
  }

  startTimer() {
    this.timer = window.setInterval(this.timerHandler, 10);
   }

  stopTimer() {
    window.clearInterval(this.timer);
   }

  getPageBySentenceId(id: string) {
    return this.idToPage.get(id) || 0;
  }

  getPageSentences(page: number) {
    if (page === this.dividePositions.length) {
      return this.readerStore.sentences.slice(this.dividePositions[page - 1] || 0);
    }
    return this.readerStore.sentences.slice(
      this.dividePositions[page - 1] || 0,
      this.dividePositions[page]
    );
  }

  selectWord(word: string, i: number, sentenceId: string) {
    this.unknownWords.push({
      word: word,
      wordIndex: i,
      sentenceId: sentenceId,
      time: this.currentTime,
    });
  }

  paginate(sens: string[]) {
    this.readerStore.paginate(sens, this.currentTime, this.unknownWords);
    this.unknownWords = [];
    this.currentTime = 0;
  }

  cancelSelection() {
    this.onCancelSelection.trigger();
  }

  @action changePage(page: number) {
    const sens = this.getPageSentences(page).map(x => x.id);
    const old = this.getPageBySentenceId(this.readerStore.location.sentenceId) || 0;
    const neww = this.getPageBySentenceId(sens[0]) || 0;
    if (this.cutted) {
      this.readerStore.location.sentenceId = sens[0];
    }
    if (neww > old) {
      const sens = this.getPageSentences(old).map(x => x.id);
      this.paginate(sens);
    } else if(neww < old) {
      this.currentTime = 0;
    }
    this.currentTime = 0;
  }

  @computed get currentPageSentences() {
    return this.getPageSentences(this.getPageBySentenceId(this.readerStore.location.sentenceId))
  }

  @computed get idToPage() {
    return Array(this.dividePositions.length + 1)
      .fill(1)
      .flatMap((_: any, i: number) =>
        this.getPageSentences(i).map(sen => [sen.id, i])
      )
      .reduce((map: Map<string, number>, tuple: any) => {
        map.set(tuple[0], tuple[1]);
        return map;
      }, new Map());
  }

  @action moveChapter(id: string) {
    this.clearDivision();
    this.readerStore.location.chapterId = id;
  }

  @action nextChapter() {
    const sens = this.currentPageSentences.map(x => x.id);
    this.paginate(sens);
    this.clearDivision();
    this.readerStore.nextChapter();
  }

  @action prevChapter() {
    this.clearDivision();
    this.readerStore.prevChapter();
  }

  @action clearDivision() {
    this.cutted = false;
    this.loaded = false;
    this.dividePositions = [];
  }
}

export default ReaderUIStore;