import { observable, action, computed, reaction } from "mobx";
import RootStore from '../../core/stores/RootStore';
import { User, BookyBook, Book, SelectedWord } from "../../core/models";
import FirebaseService from "../../core/stores/FirebaseService";
import { LiteEvent } from "../../core/utils/event";
import ReaderRootStore, { ReaderStore } from "./ReaderRootStore";
import { PaginateWordUnknown } from "../../core/models/Log";
import React from "react";

export interface LookUp {
  id: string;
  msg: string;
  duration: number;
}

class ReaderUIStore {
  readerRootStore: ReaderRootStore;
  rootStore: RootStore;

  @observable lookUp: LookUp | undefined = undefined;
  @observable cutted: Boolean = false;
  @observable loaded: Boolean = false;
  @observable dividePositions: number[] = [];
  @observable fontSize: number = 20;
  @observable selectedWord?: SelectedWord;
  timer: ReturnType<typeof setInterval> = -1;

  onCancelSelection: LiteEvent<void> = new LiteEvent();
  readerStore: ReaderStore;

  currentTime: number = 0;
  unknownWords: PaginateWordUnknown[] = [];

  constructor(readerRootStore: ReaderRootStore) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
    this.readerStore = readerRootStore.readerStore;
    this.startTimer();
    window.addEventListener('focus', this.startTimer.bind(this));
    window.addEventListener('blur', this.stopTimer.bind(this));
    reaction(() => this.cutted, cutted => {
      if (cutted) {
        this.currentTime = 0;
      }
    });
  }

  timerHandler() {
    this.currentTime+=100;
  }

  startTimer() {
    if (this.timer !== -1) {
      this.stopTimer();
    }
    this.timer = window.setInterval(this.timerHandler, 100);
   }

  stopTimer() {
    window.clearInterval(this.timer);
    this.timer = -1;
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
    console.log(this.currentTime);
    this.currentTime = 0;
  }

  cancelSelection() {
    this.onCancelSelection.trigger();
  }

  @action changePage(page: number) {
    const sens = this.getPageSentences(page).map(x => x.id);
    const old = this.getPageBySentenceId(this.readerStore.currentSentenceId) || 0;
    const neww = this.getPageBySentenceId(sens[0]) || 0;
    if (this.cutted) {
      this.readerStore.setCurrentSentenceId(sens[0]);
      if (neww > old) {
        const sens = this.getPageSentences(old).map(x => x.id);
        this.paginate(sens);
      } else if(neww < old) {
        const sens = this.getPageSentences(old).map(x => x.id);
        this.paginate(sens);
      }
    }
  }

  @computed get currentPageSentences() {
    return this.getPageSentences(this.getPageBySentenceId(this.readerStore.currentSentenceId))
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

  @action nextSection() {
    const sens = this.currentPageSentences.map(x => x.id);
    this.paginate(sens);
    this.clearDivision();
    this.readerStore.nextSection();
  }

  @action prevSection() {
    this.clearDivision();
    this.readerStore.prevSection();
  }

  @action clearDivision() {
    console.log('clearDivision');
    this.cutted = false;
    this.loaded = false;
    this.dividePositions = [];
  }
}

export default ReaderUIStore;
