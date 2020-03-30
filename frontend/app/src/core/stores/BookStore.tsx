import { observable, action, observe, autorun } from "mobx";
import RootStore from './RootStore';
import { User, Book, BookyBook } from "../models";
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
      const path = window.require('path');
      fs.mkdirSync(this.booksDir(), { recursive: true });
      fs.readdir(this.booksDir(), (err: any, files: any) => {
        files.forEach((file: any) => {
          console.log(file.replace(/\.book$/, ""));
          this.downloaded.set(file.replace(/\.book$/, ""), path.join(this.booksDir(), file));
        });
      });
    } else if (isPlatform('hybrid')) {
      const files = await File.listDir(File.dataDirectory, 'books');
      files.forEach(file => {
        this.downloaded.set(file.name.replace(/\.book$/, ""), file.fullPath);
      });
    } else {
      this.books.forEach(x => {this.downloaded.set(x.id, 'yes')});
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
    } else if (isPlatform('hybrid')) {
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

  async open(id: string): Promise<BookyBook> {
    if (isPlatform('electron')) {
      const file = this.downloaded.get(id);
      const fs = window.require('fs');
      return new Promise((resolve, reject) => {
        fs.readFile(file,  "utf8", (err: any, buf:any) => {
          if (err) {
            reject(err);
            return;
          }
          resolve(JSON.parse(buf.toString()) as BookyBook);
        });
      });
    } else {
      const url = this.books.find(x => x.id === id)!.downloadLink;
      return fetch(url).then(x => x.json()).then(x => (x as BookyBook));
    }
  }
}

export default BookStore;
