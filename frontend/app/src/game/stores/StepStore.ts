import { Step, Review } from "../models/Game";

import RootStore from "../../core/stores/RootStore";

import GameStore from "./GameStore";

export interface StepStore {
  gameStore?: GameStore;
  saveData(): object;
  loadData(data: object): void;
  destroy(): void;
  setDisposers(diposes: (() => void)[]): void;
}

export abstract class BaseStepStore {
  gameStore?: GameStore;
  private disposers: (() => void)[] = [];

  destroy() {
    this.disposers.forEach(x => {
      x();
    });
  }

  abstract saveData(): any;

  save() {
    this.gameStore!.saveStep(this.saveData());
  }

  setDisposers(disposers: (() => void)[]) {
    this.disposers = disposers;
  }
}

export interface StepComponent {
  storeGenerator?: StepStoreGenerator;
  substeps: SubStep[];
}

export type SubStep = React.FC<{ store?: StepStore }> | React.SFC;

export type StepStoreGenerator = (
  step: Step,
  review: Review,
  rootStore: RootStore
) => StepStore;

export function wrapStore(
  gameStore: GameStore,
  step: number,
  store: StepStore
) {
  if (gameStore.progress.savedata[step.toString()]) {
    store.loadData(gameStore.progress.savedata[step.toString()]);
  }
  store.gameStore = gameStore;
  return store;
}
