import {
  Progress,
  Review,
  generateProgress,
  LastWord,
  StepKind
} from "../models/Game";
import { observable, computed, action, autorun } from "mobx";
import RootStore from "../../core/stores/RootStore";
import { Message } from "../models/Dialog";
import LogStore from "../../core/stores/LogStore";
import { autobind } from "core-decorators";
import {
  LogReviewStartPayload,
  LogReviewPaginatePayload,
  PaginateWordUnknown,
  LogReviewEndPayload
} from "../../core/models/Log";
import { LiteEvent } from "../../core/utils/event";
import UserStore from "../../core/stores/UserStore";

@autobind
class GameStore {
  logStore: LogStore;
  userStore: UserStore;
  @observable substepI: number = 0;
  @observable substep: number = 0;
  @observable step: number = 0;

  @computed get canNext(): boolean {
    return this._nextCallback != null;
  }

  @computed get canGiveup(): boolean {
    return this._giveupCallback != null;
  }

  @computed get canComplete(): boolean {
    return this._completeCallback != null;
  }

  @observable msgs?: Message[];

  @observable currentLastWord: LastWord | null;
  @observable clickedRectangle: ClientRect | null;

  @observable msgIndex: number = 0;
  @observable ended: boolean = false;

  @observable _nextCallback: (() => void) | null = null;
  @observable _giveupCallback: (() => void) | null = null;
  @observable _completeCallback: (() => void) | null = null;
  msgCallback: (() => void) | undefined = undefined;

  onCancelLastWordDetail: LiteEvent<void> = new LiteEvent();

  progress: Progress;
  constructor(rootStore: RootStore, review: Review) {
    this.logStore = rootStore.logStore;
    this.userStore = rootStore.userStore;
    this.progress = generateProgress(review);
    this.step = this.progress.step;
    this.currentLastWord = null;
    this.clickedRectangle = null;
    this.logStart();
    autorun(() => {
      if (this.ended) {
        (async () => {
          this.userStore.saveLastReviewEnd(this.progress.review.end);
          this.logEnd();
        })();

      }
    });
  }

  @action complete() {
    if (this._completeCallback) {
      this._completeCallback();
      this._completeCallback = null;
    }
  }

  @action giveup() {
    if (this._giveupCallback) {
      this._giveupCallback();
      this._giveupCallback = null;
    }
  }

  @action next() {
    if (this._nextCallback) {
      this._nextCallback();
      this._nextCallback = null;
    }
  }

  @action nextStep() {
    if (this.step !== this.progress.steps.length - 1) {
      this.step++;
      this.substep = 0;
      this.logStart();
    } else {
      this.ended = true;
    }
  }

  @action gotoSubstep(step: number) {
    this.substep = step;
    this.substepI++;
  }

  @action nextSubStep() {
    this.substep++;
  }

  @action nextMsg() {
    if (this.msgIndex !== this.msgs!.length - 1) {
      this.msgIndex++;
      const goToSubstep = this.msgs![this.msgIndex].goToSubstep;
      if (goToSubstep) {
        this.substep = goToSubstep;
      }
    } else {
      this.msgs = undefined;
      if (this.msgCallback) {
        this.msgCallback();
        this.msgCallback = undefined;
      }
    }
  }

  @action pushDialog(msgs: Message[], callback?: () => void) {
    this.msgs = msgs;
    this.msgIndex = 0;
    this.msgCallback = callback;
  }

  @action setComplete(callback: () => void) {
    this._completeCallback = callback;
  }

  @action setGiveup(callback: () => void) {
    this._giveupCallback = callback;
  }

  @action setNext(callback: () => void) {
    this._nextCallback = callback;
  }

  @action clearNext() {
    this._nextCallback = null;
  }

  private logEnd() {
    const payload: LogReviewEndPayload = {
      type: "review-end",
      reviewId: this.progress.review.id
    };
    this.logStore.sendSync(payload);
  }

  private logStart() {
    const kind = this.progress.steps[this.step].kind;
    if (kind === StepKind.LWReview) {
      const payload: LogReviewStartPayload = {
        type: "review-start",
        reviewId: this.progress.review.id,
        step: "last-words"
      };
      this.logStore.sendSync(payload);
    } else if (kind === StepKind.UWReview) {
      const payload: LogReviewStartPayload = {
        type: "review-start",
        reviewId: this.progress.review.id,
        step: "unfamiliar-words"
      };
      this.logStore.sendSync(payload);
    }
  }

  logPaginate(
    targetWords: string[],
    contents: string[],
    sids: string[],
    time: number,
    wordUnknowns: PaginateWordUnknown[]
  ) {
    // TODO add unfamliar
    const payload: LogReviewPaginatePayload = {
      type: "review-paginate",
      reviewId: this.progress.review.id,
      content: contents,
      sids: sids,
      time: time,
      step: "last-words",
      wordUnknowns: wordUnknowns,
      targetWords: targetWords
    };
    this.logStore.sendSync(payload);
  }

  updateProgress() {}
}

export default GameStore;
