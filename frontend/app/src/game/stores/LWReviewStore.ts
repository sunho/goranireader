import {
  UnfamiliarWord,
  UWReviewStep,
  Review,
  LastWord,
  LWReviewStep
} from "../models/Game";
import { observable, toJS, action } from "mobx";
import RootStore from "../../core/stores/RootStore";
import { Text } from "../models/Game";
import { BaseStepStore } from "./StepStore";
import { autobind } from "core-decorators";
import { LogLWReviewCompletePayload, LogLWReviewGiveupPayload, LogLWReviewNextPayload, LogReviewStartPayload } from "../../core/models/Log";
import LogStore from '../../core/stores/LogStore';

@autobind
class LWReviewStore extends BaseStepStore {
  reviewWords: LastWord[];
  targetLastWords: number;
  review: Review;

  currentTime: number = 0;

  @observable previousWords: string[] = [];
  @observable completedWords: number = 0;

  timer: ReturnType<typeof setInterval> = -1;
  logStore: LogStore;

  constructor(
    step: LWReviewStep,
    review: Review,
    rootStore: RootStore
  ) {
    super();
    this.review = review;
    this.logStore = rootStore.logStore;
    this.reviewWords = review.lastWords;
    this.targetLastWords = review.targetLastWords;
    window.addEventListener('focus', this.startTimer.bind(this));
    window.addEventListener('blur', this.stopTimer.bind(this));
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

  sampleWords() {
    return this.reviewWords
      .filter(x => !this.previousWords.includes(x.word))
  }

  @action finalize(words: string[], selectedWords: string[]) {
    this.logNext(words, selectedWords);
    this.previousWords = this.previousWords.concat(words);
    this.completedWords += words.length;
    this.save();
    const out = this.shouldComplete();
    if (out) {
      this.logComplete();
    }
    return out;
  }

  saveData(): object {
    return {
      previousWords: toJS(this.previousWords),
      completedWords: toJS(this.completedWords),
    };
  }

  loadData(data: any) {
    this.previousWords = data.previousWords || [];
    this.completedWords = data.completedWords || 0;
  }

  shouldComplete() {
    return this.previousWords.length === this.reviewWords.length;
  }

  canComplete() {
    return this.completedWords >= this.targetLastWords || this.shouldComplete();
  }

  canGiveup() {
    return this.targetLastWords >= 1;
  }

  logComplete() {
    const payload: LogLWReviewCompletePayload = {
      type: 'last-words-review-complete',
      reviewId: this.review.id,
      time: this.currentTime,
      words: this.reviewWords.map(x => x.word),
      completedWords: this.completedWords,
      targetCompletedWords: this.targetLastWords
    };
    this.currentTime = 0;
    this.logStore.sendSync(payload);
  }

  private logNext(visibleWords: string[], selectedWords: string[]) {
    const payload: LogLWReviewNextPayload = {
      type: 'last-words-review-next',
      reviewId: this.review.id,
      visibleWords: visibleWords,
      selectedWords: selectedWords,
      time: this.currentTime,
      words: this.reviewWords.map(x => x.word),
      previousCompletedWords: this.completedWords,
      targetCompletedWords: this.targetLastWords
    };
    this.currentTime = 0;
    this.logStore.sendSync(payload);
  }

  logGiveup() {
    const payload: LogLWReviewGiveupPayload = {
      type: 'last-words-review-giveup',
      reviewId: this.review.id,
      time: this.currentTime,
      words: this.reviewWords.map(x => x.word),
      completedWords: this.completedWords,
      targetCompletedWords: this.targetLastWords
    };
    this.currentTime = 0;
    this.logStore.sendSync(payload);
  }

}

export default LWReviewStore;
