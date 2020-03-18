import { autobind } from "core-decorators";
import RootStore from "./RootStore";


@autobind
class LogStore {
  rootStore: RootStore;
  constructor(rootStore: RootStore) {
    this.rootStore = rootStore;
  }


}

export default LogStore;
