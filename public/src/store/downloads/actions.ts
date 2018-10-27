import { action } from 'typesafe-actions'
import { DownloadsActionTypes, Download } from './types'
import { Dispatch } from 'redux';
import { Book, addBook, addBookPath } from '../books';
import * as content from '../../modules/content'

const addDownload = (download: Download) => action(DownloadsActionTypes.ADD, download)
const progressDownload = (id: number, percent: number) => action(DownloadsActionTypes.PROGRESS, { id: id, percent: percent })
const removeDownload = (id: number) => action(DownloadsActionTypes.REMOVE, id)

export function startDownload(dispatch: Dispatch, book: Book) {
  content.startDownload(book, percent => {
    dispatch(progressDownload(book.id, percent))
  }).then(path => {
    dispatch(addBookPath(book.id, path))
    dispatch(removeDownload(book.id))
  }).catch(() => {
    dispatch(removeDownload(book.id))
  })

  dispatch(addDownload({
    id: book.id,
    percent: 0
  }))
}
