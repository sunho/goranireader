import FireBaseService from './FirebaseService';
import { autobind } from 'core-decorators';
import UserStore from './UserStore';
import AlertStore from './AlertStore';
import BookStore from './BookStore';
import DictService from './DictService';
import { BookyBook } from '../models';
import ReaderStore from './ReaderStore';
import RootStore from './RootStore';
import ReaderUIStore from './ReaderUIStore';

@autobind
class ReaderRootStore {
  rootStore: RootStore;
  readerStore: ReaderStore;
  readerUIStore: ReaderUIStore;
  constructor(rootStore: RootStore, book: BookyBook) {
    this.rootStore = rootStore;
    this.readerStore = new ReaderStore(this, book);
    this.readerUIStore = new ReaderUIStore(this);
  }
};

export default ReaderRootStore;
