import FireBaseService from '../../core/stores/FirebaseService';
import { autobind } from 'core-decorators';
import UserStore from '../../core/stores/UserStore';
import AlertStore from '../../core/stores/AlertStore';
import BookStore from '../../core/stores/BookStore';
import DictService from '../../core/stores/DictService';
import { BookyBook } from '../../core/models';
import ReaderStore from './ReaderStore';
import RootStore from '../../core/stores/RootStore';
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
