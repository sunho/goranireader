import { Step, Review } from "../models/Game";

import RootStore from "../../core/stores/RootStore";

import GameStore from "./GameStore";

import { isObservable, observe } from "mobx";

export interface StepStore {
  saveData(): object;
  loadData(data: object): void;
  destroy(): void;
  setDisposers(diposes: (() => void)[]): void;
}

export class BaseStepStore {
  private disposers: (() => void)[] = [];

  destroy() {
    this.disposers.forEach(x => {x()});
  }

  setDisposers(disposers: (() => void)[]) {
    this.disposers = disposers;
  }
}

export interface StepComponent {
  storeGenerator?: StepStoreGenerator;
  substeps: SubStep[];
}

export type SubStep = React.FC<{store?: StepStore}> | React.SFC;

export type StepStoreGenerator = (step: Step, review: Review, rootStore: RootStore) => StepStore;

export function wrapStore(gameStore: GameStore, step: number, store: StepStore) {
  store.setDisposers(Object.values(store).filter(x => isObservable(x)).map(x =>
    (observe(x, () => {
      gameStore.progress.savedata[step] = store.saveData();
    }))
  ));
  return store;
}
