import {
  UnfamiliarWord,
  UWReviewStep,
  Review
} from "../models/Game";
import { observable } from "mobx";
import RootStore from "../../core/stores/RootStore";
import { Text } from "../models/Game";
import { BaseStepStore } from "./StepStore";
import { autobind } from "core-decorators";

@autobind
class UWReviewStore extends BaseStepStore {
  reviewWords: UnfamiliarWord[];
  avaliableTexts: Text[];
  targetCompletedTexts: number;

  @observable completedTexts: number = 0;
  @observable previousWords: string[] = [];
  @observable previousTexts: number[] = [];

  // TODO separate these ui states
  encounteredWords: string[] = [];
  selectedTexts: number[] = [];
  suggestedTexts: Text[] = [];
  textPos: number = 0;

  constructor(
    step: UWReviewStep,
    review: Review,
    rootStore: RootStore
  ) {
    super();
    this.reviewWords = review.unfamiliarWords;
    this.avaliableTexts = review.texts;
    this.targetCompletedTexts = review.targetCompletedTexts;
  }

  sampleWords() {
    return this.reviewWords
      .map(x => x.word)
      .filter(x => !this.previousWords.includes(x))
      .slice(0, 1);
  }

  suggestTexts(selectedWords: string[]) {
    const reviewWords = this.reviewWords.filter(x =>
      selectedWords.includes(x.word)
    );
    const occurs = reviewWords.flatMap(x => x.texts);
    const freq = occurs.reduce(
      (acc, e) => acc.set(e, (acc.get(e) || 0) + 1),
      new Map<number, number>()
    );
    const ranknedTexts = Array.from(freq.entries())
      .filter(x => (x[1] !== 0))
      .sort((x, y) => x[1] - y[1])
      .map(x => x[0]);
    const suggested = ranknedTexts.filter(x => !this.previousTexts.includes(x));
    return suggested.slice(0, 3);
  }

  finalizePickWords(selectedWords: string[], encounteredWords: string[]) {
    this.encounteredWords = encounteredWords;
    const texts = this.suggestTexts(selectedWords);
    if (texts.length === 0) {
      this.previousWords = this.previousWords.concat(this.encounteredWords);
      this.encounteredWords = [];
      return false;
    }
    this.selectedTexts = texts;
    this.suggestedTexts = texts.map(x => this.avaliableTexts[x]);
    this.textPos = 0;
    return true;
  }

  finalizeReadText() {
    this.previousWords = this.previousWords.concat(this.encounteredWords);
    this.previousTexts = this.previousTexts.concat(this.selectedTexts);
    this.completedTexts += this.suggestedTexts.length;
    this.encounteredWords = [];
    this.selectedTexts = [];
    return this.shouldComplete();
  }

  saveData(): object {
    return {};
  }

  loadData(data: object) {}

  shouldComplete() {
    return this.previousWords.length === this.reviewWords.length || this.previousTexts.length === this.avaliableTexts.length;
  }

  canComplete() {
    return this.completedTexts >= this.targetCompletedTexts || this.shouldComplete();
  }

  canGiveup() {
    return this.completedTexts >= 1;
  }
}

export default UWReviewStore;
