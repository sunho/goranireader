import { Progress, Review, generateProgress, LastWord } from "../models/Game";
import { observable, computed, action } from "mobx";
import RootStore from "../../core/stores/RootStore";
import { Message } from "../models/Dialog";

class GameStore {
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

  @observable _nextCallback: (() => void) | null = null;
  @observable _giveupCallback: (() => void) | null = null;
  @observable _completeCallback: (() => void) | null = null;

  progress: Progress;
  constructor(rootStore: RootStore, review: Review) {
    this.progress = generateProgress(review);
    this.step = this.progress.step;
    this.currentLastWord = null;
    this.clickedRectangle = null;
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
    this.step ++;
  }

  @action gotoSubstep(step: number) {
    this.substep = step;
  }

  @action nextSubStep() {
    this.substep ++;
  }

  @action nextMsg() {
    if (this.msgIndex !== this.msgs!.length - 1) {
      this.msgIndex ++;
      const goToSubstep = this.msgs![this.msgIndex].goToSubstep;
      if (goToSubstep) {
        this.substep = goToSubstep;
      }
    } else {
      this.msgs = undefined;
    }
  }

  @action pushDialog(msgs: Message[]) {
    this.msgs = msgs;
    this.msgIndex = 0;
  }

  @action setNext(callback: ()=>void) {
    this._nextCallback = callback;
  }

  @action clearNext() {
    this._nextCallback = null;
  }

  updateProgress() {

  }
}


export default GameStore;
