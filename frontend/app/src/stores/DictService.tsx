import { SqlJs } from "sql.js/module";
import { autobind } from "core-decorators";

@autobind
class DictService {
  db: SqlJs.Database | undefined = undefined;
  constructor() {
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

  }
};

export default DictService;
