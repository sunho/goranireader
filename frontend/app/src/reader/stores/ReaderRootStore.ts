import FireBaseService from '../../core/stores/FirebaseService';
import { autobind } from 'core-decorators';
import UserStore from '../../core/stores/UserStore';
import AlertStore from '../../core/stores/AlertStore';
import BookStore from '../../core/stores/BookStore';
import DictService from '../../core/stores/DictService';
import { BookyBook, Item } from '../../core/models';
import RootStore from '../../core/stores/RootStore';
import ReaderUIStore from './ReaderUIStore';
import { PaginateWordUnknown } from '../../core/models/Log';
import React from 'react';

class ReaderRootStore {
  rootStore: RootStore;
  readerStore: ReaderStore;
  readerUIStore: ReaderUIStore;
  constructor(rootStore: RootStore, readerStore: ReaderStore) {
    this.rootStore = rootStore;
    this.readerStore = readerStore;
    this.readerStore.init(this);
    this.readerUIStore = new ReaderUIStore(this);
  }
};

export interface ReaderStore {
  init(store: ReaderRootStore): void;

  sentences: Item[];

  currentSentenceId: string;
  setCurrentSentenceId(sid: string): void;

  atStart: boolean;
  atEnd: boolean;

  nextSection(): void;
  prevSection(): void;

  paginate(sids: string[], time: number, words: PaginateWordUnknown[]): void;
}

export const ReaderContext = React.createContext<ReaderRootStore | null>(null);

export default ReaderRootStore;
