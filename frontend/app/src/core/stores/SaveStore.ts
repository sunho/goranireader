import { autobind } from "core-decorators";
import { Save } from "../models/Save";
import migrator from '../models/migrations/save';
import { Plugins } from '@capacitor/core';

const { Storage } = Plugins

@autobind
class SaveStore {
  current?: Save;
  constructor() { }

  async init() {
    await this.load();
  }

  async save() {
    await Storage.set({key: 'save', value: JSON.stringify(this.current!)});
  }

  async load() {
    const ret = await Storage.get({key: 'save'});
    if (ret.value) {
      this.current = migrator.migrate(JSON.parse(ret.value));
      console.log(this.current);
    } else {
      this.current = migrator.default();
    }
  }
}

export default SaveStore;
