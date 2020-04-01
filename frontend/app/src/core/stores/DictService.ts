import { autobind } from "core-decorators";
import { EnglishWords } from "../nlp/words";

@autobind
class DictService {
  db: any | undefined = undefined;
  words: EnglishWords;
  constructor() {
    this.words = new EnglishWords();
    const init = () => {
      console.log("init");
      initSqlJs({
        locateFile: (file: any) => `${process.env.PUBLIC_URL}/assets/${file}`
      })
        .then((sql: any) => {
          const SQL = sql;

          const xhr = new XMLHttpRequest();
          xhr.open("GET", `${process.env.PUBLIC_URL}/assets/dict.db`, true);
          xhr.responseType = "arraybuffer";

          xhr.onload = e => {
            const uInt8Array = new Uint8Array(xhr.response);
            this.db = new SQL.Database(uInt8Array);
          };

          xhr.send();
        })
        .catch(e => {
          init();
        });
    };
    init();
  }

  find(word: string) {
    return this.words
      .normalizedForms(word)
      .map(this.getWord)
      .filter(x => x !== undefined);
  }

  getWord(word: string) {
    if (!this.db) return undefined;
    const stmt = this.db.prepare("SELECT * FROM words WHERE word = $word");
    stmt.bind({ $word: word });
    if (stmt.step()) {
      const row: any = stmt.getAsObject();
      row.defs = this.getDefinitions(word);
      return row;
    }
    return undefined;
  }

  getDefinitions(word: string) {
    if (!this.db) return [];
    const stmt = this.db.prepare("SELECT * FROM defs WHERE word = $word");
    stmt.bind({ $word: word });
    const out = [];
    while (stmt.step()) {
      out.push(stmt.getAsObject());
    }
    return out;
  }
}

export default DictService;
