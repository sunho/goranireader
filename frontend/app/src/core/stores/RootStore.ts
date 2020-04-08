import FireBaseService from './FirebaseService';
import { autobind } from 'core-decorators';
import UserStore from './UserStore';
import AlertStore from './AlertStore';
import BookStore from './BookStore';
import DictService from './DictService';
import LogStore from './LogStore';
import SaveStore from './SaveStore';

@autobind
class RootStore {
  firebaseService: FireBaseService;
  userStore: UserStore;
  alertStore: AlertStore;
  bookStore: BookStore;
  dictService: DictService;
  logStore: LogStore;
  saveStore: SaveStore;

  constructor() {
    this.firebaseService = new FireBaseService();
    this.dictService = new DictService();
    this.userStore = new UserStore(this);
    this.alertStore = new AlertStore(this);
    this.bookStore = new BookStore(this);
    this.logStore = new LogStore(this);
    this.saveStore = new SaveStore();
  }
};

export default RootStore;

export const createStore = () => {
  return new RootStore();
};

export type TStore = ReturnType<typeof createStore>
