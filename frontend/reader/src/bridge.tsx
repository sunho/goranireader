import { Sentence } from "./model";
import { LiteEvent } from "./utills/event";

export interface App {
  initComplete(): void;
  loadComplete(): void;
  atStart(): void;
  atMiddle(): void;
  atEnd(): void;
  paginate(sids: string[]): void;
  wordSelected(i: number, sid: string): void;
  sentenceSelected(sid: string): void;
  readingSentenceChange(sid: String): void;
}

export class Webapp {
  readonly onFlushPaginate = new LiteEvent<void>();
  readonly onCancelSelect = new LiteEvent<void>();
  readonly onStart = new LiteEvent<{sentences: Sentence[], sid: string}>();

  setDev() {
    window.app = new DevAppImpl();
  }

  setIOS() {}

  start(sentences: Sentence[], sid: string) {
    console.log("fafasfdasf");
    this.onStart.trigger({
      sentences: sentences,
      sid: sid
    });
  }

  flushPaginate() {
    this.onFlushPaginate.trigger();
  }

  cancelSelect() {
    this.onCancelSelect.trigger();
  }
}

class DevAppImpl implements App {
  constructor() {}

  initComplete() {
    console.log("[app] init complete");
  }

  loadComplete() {
    console.log("[app] loadComplete used");
  }

  atStart() {
    console.log("[app] at start");
  }

  atMiddle() {
    console.log("[app] at middle");
  }

  atEnd() {
    console.log("[app] at end");
  }

  wordSelected(i: number, sid: string) {
    console.log("[app] at end i: " + i + " sid:" + sid);
  }

  paginate(sids: string[]) {
    console.log("[app] paginate sids");
    console.log(sids)
  }

  sentenceSelected(sid: string) {
    console.log("[app] sentence selected sid:"+ sid);
  }

  readingSentenceChange(sid: string) {
    console.log("[app] reading setence changed");
  }
}
