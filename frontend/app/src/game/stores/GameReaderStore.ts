import RootStore from "../../core/stores/RootStore";
import { Sentence, Item } from "../../core/models";
import { autobind } from "core-decorators";
import ReaderRootStore, {
  ReaderStore
} from "../../reader/stores/ReaderRootStore";
import {
  PaginateWordUnknown,
} from "../../core/models/Log";
import GameStore from "./GameStore";

export interface Location {
  chapterId: string;
  sentenceId: string;
}

@autobind
class GameReaderStore implements ReaderStore {
  rootStore: RootStore | null = null;
  sentences: Item[];
  targetWords: string[];
  readerRootStore: ReaderRootStore | null = null;
  sentenceId: string = "";
  gameStore: GameStore;
  constructor(sentences: Item[], gameStore: GameStore, targetWords: string[]) {
    this.sentences = sentences;
    this.gameStore = gameStore;
    this.targetWords = targetWords;
    this.gameStore.onCancelLastWordDetail.on(this.onCancel);
  }

  init(readerRootStore: ReaderRootStore) {
    this.readerRootStore = readerRootStore;
    this.rootStore = readerRootStore.rootStore;
  }

  onCancel() {
    this.readerRootStore!.readerUIStore.flushPaginate();
  }

  get atStart() {
    return true;
  }

  get atEnd() {
    return true;
  }

  nextSection() {}

  get currentSentenceId() {
    return this.sentenceId;
  }

  setCurrentSentenceId(sid: string) {
    this.sentenceId = sid;
  }

  prevSection() {}

  paginate(sids: string[], time: number, words: PaginateWordUnknown[]) {
    const contents = this.sentences
      .filter(x => x.kind === "sentence")
      .filter(x => sids.includes(x.id))
      .map(x => (x as Sentence).content);

    this.gameStore.logPaginate(this.targetWords, contents, sids, time, words);
  }

  destroy() {
    this.gameStore.onCancelLastWordDetail.off(this.onCancel);
  }
}

export default GameReaderStore;
