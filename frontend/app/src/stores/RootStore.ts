import FireBaseService from './FirebaseService';
import { autobind } from 'core-decorators';
import UserStore from './UserStore';
import AlertStore from './AlertStore';
import BookStore from './BookStore';
import DictService from './DictService';

@autobind
class RootStore {
  firebaseService: FireBaseService;
  userStore: UserStore;
  alertStore: AlertStore;
  bookStore: BookStore;
  dictService: DictService;
  constructor() {
    this.firebaseService = new FireBaseService();
    this.dictService = new DictService();
    this.userStore = new UserStore(this);
    this.alertStore = new AlertStore(this);
    this.bookStore = new BookStore(this);
  }
};

export default RootStore;

export const createStore = () => {
  return new RootStore();
};

export type TStore = ReturnType<typeof createStore>
