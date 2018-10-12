import { action } from 'typesafe-actions'
import { BooksActionTypes, Book } from './types'

export const add = (book: Book) => action(BooksActionTypes.ADD, book)
