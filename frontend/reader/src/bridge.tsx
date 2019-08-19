import { Sentence, DictSearchResult } from "./model";
import { LiteEvent } from "./utills/event";

export interface App {
  initComplete(): void;
  setLoading(loading: boolean): void;
  atStart(): void;
  atMiddle(): void;
  atEnd(): void;
  paginate(sids: string[]): void;
  wordSelected(i: number, sid: string): void;
  sentenceSelected(sid: string): void;
  readingSentenceChange(sid: string): void;
  dictSearch(word: string): string;
  addUnknownWord(sid: string, wordIndex: number, word: string, def: string): void;
  addUnknownSentence(sid: string): void;
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

  setLoading(load: boolean) {
    console.log("[app] loading: " + load);
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

  dictSearch(word: string): string {
    const out: DictSearchResult = {
      addable: false,
      words: [
        {
          word: "hello",
          pron: "",
          defs: [
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            }
          ]
        },
        {
          word: "hello",
          pron: "",
          defs: [
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            },
            {
              def: "asdfasf",
              id: 1,
            }
          ]
        }
      ]
    };
    return JSON.stringify(out);
  }

  addUnknownSentence(sid: string) {
    console.log(`addUnknownSentence sid: ${sid}`);
  }

  addUnknownWord(sid: string, wordIndex: number, word: string, def: string) {
    console.log(`addUnknownWord sid: ${sid} wordIndex: ${wordIndex} word: ${word} def: ${def}`);
  }
}
