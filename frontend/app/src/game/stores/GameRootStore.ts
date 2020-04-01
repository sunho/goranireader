import React from "react";
import RootStore from "../../core/stores/RootStore";
import GameStore from "./GameStore";
import { Review } from "../models/Game";
import { autobind } from "core-decorators";

@autobind
class GameRootStore {
  rootStore: RootStore;
  gameStore: GameStore;
  constructor(rootStore: RootStore, review: Review) {
    this.rootStore = rootStore;
    this.gameStore = new GameStore(rootStore, review);
  }
};

export const GameContext = React.createContext<GameRootStore | null>(null);

export default GameRootStore;
