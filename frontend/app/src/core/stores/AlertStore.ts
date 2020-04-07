import { observable, action } from "mobx";
import RootStore from "./RootStore";
import { User } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";

export interface AlertMessage {
  id: string;
  msg: string;
  duration: number;
}

@autobind
class AlertStore {
  private i: number = 0;
  rootStore: RootStore;
  @observable msgs: AlertMessage[] = [];

  constructor(rootStore: RootStore) {
    this.rootStore = rootStore;
  }

  add(msg: string, duration: number) {
    this.msgs.unshift({
      id: (this.i + 1).toString(),
      msg: msg,
      duration: duration
    });
    this.i++;
  }

  remove(id: string) {
    this.msgs = this.msgs.filter(x => x.id !== id);
  }
}

export default AlertStore;
