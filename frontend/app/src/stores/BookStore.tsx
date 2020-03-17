import { observable, action, observe, autorun } from "mobx";
import RootStore from './RootStore';
import { User, Book } from "../models";
import FirebaseService from "./FirebaseService";
import { autobind } from "core-decorators";
import { FileTransfer, FileUploadOptions, FileTransferObject } from '@ionic-native/file-transfer';
import { File } from '@ionic-native/file';
import { isPlatform } from '@ionic/react';
import { resolve } from "url";

@autobind
class BookStore {
  private i: number = 0;
  private transfers: Map<string, any> = new Map();
  private transfer = FileTransfer;
  rootStore: RootStore;
  @observable downloaded: Map<string, string> = new Map();
  @observable books: Book[] = [];

  constructor(rootStore: RootStore) {
    this.rootStore = rootStore;
    autorun(() => {
      if (!this.rootStore.userStore.userId) {
        this.refresh().catch(() => {});
      }
    });
  }

  dataDir() {
    const process = window.process;
    return process.env.APPDATA || (process.platform === 'darwin' ? process.env.HOME + '/Library/Preferences' : process.env.HOME + "/.local/share")
  }

  booksDir() {
    const path = window.require('path');
    return path.join(this.dataDir(), 'gorani-reader', 'books');
  }

  @action async refresh() {
    const docs = await this.rootStore.firebaseService.books().get();
    this.books = docs.docs.map(x => x.data()! as Book);
    this.downloaded.clear();
    if (isPlatform('electron')) {
      const fs = window.require('fs');
      fs.mkdirSync(this.booksDir(), { recursive: true });
      fs.readdir(this.booksDir(), (err: any, files: any) => {
        files.forEach((file: any) => {
          this.downloaded.set(file.replace(/\.book$/, ""), file.fullPath);
        });
      });
    } else {
      const files = await File.listDir(File.dataDirectory, 'books');
      files.forEach(file => {
        this.downloaded.set(file.name.replace(/\.book$/, ""), file.fullPath);
      });
    }
    return Promise.resolve();
  }

  @action async download(book: Book) {
    if (isPlatform('electron')) {
      const fs = window.require('fs');
      const http = window.require('http');
      const path = window.require('path');
      const file = fs.createWriteStream(path.join(this.booksDir(), book.id + '.book'));
      const urlParser = window.require('url');

      const supportedLibraries = {
          "http:": window.require('http'),
          "https:": window.require('https')
      };

      const parsed = urlParser.parse(book.downloadLink);
      const lib = (supportedLibraries as any)[(parsed.protocol as string) || "http:"];
      if (lib) {
        return new Promise<void>((resolve, reject) => {
          lib.get(book.downloadLink, (resp: any) => {
            resp.pipe(file);
            resolve();
          }).on('error', (e: any) => {
            reject(e);
          });
        });
      } else {
        throw new Error("invalid book download link");
      }
    } else {
      if (this.transfers.has(book.id)) this.transfers.get(book.id)!.abort();
      const fileTransfer = this.transfer.create();
      this.transfers.set(book.id, fileTransfer);
      return fileTransfer.download(book.downloadLink,  File.dataDirectory + 'books/' + book.id + '.book')
        .then(() => {
          this.transfers.delete(book.id);
          return Promise.resolve();
        })
        .catch(e => {
          this.transfers.delete(book.id);
          throw e;
        });
    }
  }

  async open() {

  }
}

export default BookStore;
