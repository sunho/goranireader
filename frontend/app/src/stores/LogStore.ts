import { autobind } from "core-decorators";
import RootStore from "./RootStore";
import { EventLogPayload, EventLog } from "../models/Log";
import uuid from 'uuid/v4';
import { ISODateString } from "../utils/util";


const url = "https://asia-northeast1-gorani-reader-249509.cloudfunctions.net/addLog";

@autobind
class LogStore {
  rootStore: RootStore;
  constructor(rootStore: RootStore) {
    this.rootStore = rootStore;
  }

  async send(payload: EventLogPayload) {
    const log: EventLog = {
      id: uuid(),
      type: payload.type,
      time: ISODateString(new Date()),
      payload: JSON.stringify(payload),
    };
    const token = await this.rootStore.firebaseService.auth.currentUser!.getIdToken(false);
    return fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: token,
      },
      body: JSON.stringify(log)
    });
  }

}

export default LogStore;
