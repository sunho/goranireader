import { Book } from "../../store/books";
import { zip, unzip, unzipAssets, subscribe } from 'react-native-zip-archive'
import * as RNFS from 'react-native-fs'

const jobs: {[id: number]: number} = {}

export const rootPath = RNFS.DocumentDirectoryPath + '/contents'

function appendize(f: (book: Book) => string) {
  return (book: Book, addRoot?: boolean) => {
    if (addRoot) {
      return rootPath + '/' + f(book)
    } else {
      return f(book)
    }
  }
}

export const bookPath = appendize((book: Book) => (book.name + book.id))

export const epubPath = appendize((book: Book) => (bookPath(book) + '/epub/'))

export async function startDownload(book: Book, progress?: (percent: number) => void) {
  if (jobs[book.id]) {
    throw new Error('download already in progress')
  }
  const path = RNFS.TemporaryDirectoryPath + '/' + book.name + Math.round(Math.random()*100000)
  const res = RNFS.downloadFile({
    fromUrl: book.src,
    toFile: path,
    progress: (res) => {
      progress && progress(res.bytesWritten / res.contentLength)
    },
  })

  jobs[book.id] = res.jobId

  return res.promise.then(() => {
    return RNFS.mkdir(bookPath(book, true))
  }).then(() => {
    return unzip(path, epubPath(book, true))
  })
}

export async function exists(book: Book) {
  return await RNFS.exists(bookPath(book, true))
}
