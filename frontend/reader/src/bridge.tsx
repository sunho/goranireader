import { Sentence, DictSearchResult, Question } from "./model";
import { LiteEvent } from "./utills/event";

export interface App {
  initComplete(): void;
  setLoading(loading: boolean): void;
  atStart(): void;
  atMiddle(): void;
  atEnd(): void;
  paginate(sids: string[]): void;
  wordSelected(word: string, i: number, sid: string): void;
  sentenceSelected(sid: string): void;
  readingSentenceChange(sid: string): void;
  dictSearch(word: string): string | Promise<string>;
  addUnknownWord(sid: string, wordIndex: number, word: string, def: string): void;
  addUnknownSentence(sid: string): void;
}

export class Webapp {
  readonly onFlushPaginate = new LiteEvent<void>();
  readonly onCancelSelect = new LiteEvent<void>();
  readonly onStartReader = new LiteEvent<{sentences: Sentence[], sid: string}>();
  readonly onStartQuiz = new LiteEvent<{questions: Question[]; qid: string}>();

  setDev() {
    window.app = new DevAppImpl();
  }

  setIOS() {
    window.app = new IOSAppImpl();
  }

  startReader(sentences: Sentence[], sid: string) {
    this.onStartReader.trigger({
      sentences: sentences,
      sid: sid
    });
  }

  startQuiz(questions: Question[], qid: string) {
    this.onStartQuiz.trigger({questions:questions, qid: qid});
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

  wordSelected(word: string, i: number, sid: string) {
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

class IOSAppImpl implements App {
  resolveDict?: (res: string) => void = undefined;
  constructor() {}

  initComplete() {
    window.webkit.messageHandlers.bridge.postMessage({type: "initComplete"})
  }

  setLoading(load: boolean) {
    window.webkit.messageHandlers.bridge.postMessage({type: "setLoading", load: load})
  }

  atStart() {
    window.webkit.messageHandlers.bridge.postMessage({type: "atStart"})
  }

  atMiddle() {
    window.webkit.messageHandlers.bridge.postMessage({type: "atMiddle"})
  }

  atEnd() {
    window.webkit.messageHandlers.bridge.postMessage({type: "atEnd"})
  }

  wordSelected(word: string, i: number, sid: string) {
    window.webkit.messageHandlers.bridge.postMessage({type: "wordSelected", i: i, sid: sid, word: word})
  }

  paginate(sids: string[]) {
    window.webkit.messageHandlers.bridge.postMessage({type: "paginate", sids: sids})
  }

  sentenceSelected(sid: string) {
    window.webkit.messageHandlers.bridge.postMessage({type: "sentenceSelected", sid: sid})
  }


  readingSentenceChange(sid: string) {
    window.webkit.messageHandlers.bridge.postMessage({type: "readingSentenceChange", sid: sid})
  }

  dictSearch(word: string): Promise<string> {
    window.webkit.messageHandlers.bridge.postMessage({type: "dictSearch", word: word})
    return new Promise((res, rej) => {
      this.resolveDict = res;
    });
  }

  dictSearchResolve(res: string) {
    if (this.resolveDict) {
      this.resolveDict(res);
    }
  }

  addUnknownSentence(sid: string) {
    window.webkit.messageHandlers.bridge.postMessage({type: "addUnknownSentence", sid: sid})
    console.log(`addUnknownSentence sid: ${sid}`);
  }

  addUnknownWord(sid: string, wordIndex: number, word: string, def: string) {
    window.webkit.messageHandlers.bridge.postMessage({type: "addUnknownWord", sid: sid, wordIndex: wordIndex, word: word, def: def})
  }
}

