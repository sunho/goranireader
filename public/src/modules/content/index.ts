import { Book } from "../../store/books";
import * as RNFS from 'react-native-fs'

const jobs: {[id: number]: number} = {}

function localPath(book: Book) {
  return RNFS.DocumentDirectoryPath + '/' + book.name + book.id
}

export async function startDownload(book: Book, progress?: (percent: number) => void) {
  if (jobs[book.id]) {
    throw new Error('download already in progress')
  }
  await RNFS.mkdir(localPath(book))
  const path = localPath(book) + '/content.epub'
  const res = RNFS.downloadFile({
    fromUrl: book.src,
    toFile: path,
    progress: (res) => {
      progress && progress(res.bytesWritten / res.contentLength)
    },
  })

  jobs[book.id] = res.jobId
  return new Promise<string>((resolve, reject) => {
    res.promise.then(() => {
      resolve(path)
    }).catch(err => {
      reject(err)
    })
  })
}

export async function exists(book: Book) {
  return await RNFS.exists(localPath(book))
}
