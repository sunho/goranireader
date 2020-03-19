import { SqlJs } from "sql.js/module";
import { autobind } from "core-decorators";
import { EnglishWords } from "../nlp/words";

@autobind
class DictService {
  db: SqlJs.Database | undefined = undefined;
  words: EnglishWords;
  constructor() {
    this.words = new EnglishWords();
    initSqlJs({
      locateFile: (file: any) => `./assets/${file}`
    }).then((sql: any) => {
      const SQL = sql;

      const xhr = new XMLHttpRequest();
      xhr.open('GET', './assets/dict.db', true);
      xhr.responseType = 'arraybuffer';

      xhr.onload = e => {
        const uInt8Array = new Uint8Array(xhr.response);
        this.db = new SQL.Database(uInt8Array);
      };

      xhr.send();
    });
  }

  find(word: string) {
    return this.words.normalizedForms(word).map(this.getWord).filter(x => x !== undefined);
  }

  getWord(word: string) {
    const stmt = this.db!.prepare("SELECT * FROM words WHERE word = $word");
    stmt.bind({$word: word});
    if(stmt.step()) {
      const row: any = stmt.getAsObject();
      row.defs = this.getDefinitions(word);
      return row;
    }
    return undefined;
  }

  getDefinitions(word: string) {
    const stmt = this.db!.prepare("SELECT * FROM defs WHERE word = $word");
    stmt.bind({$word: word});
    const out = [];
    while(stmt.step()) {
      out.push(stmt.getAsObject());
    }
    return out;
  }
};

export default DictService;
