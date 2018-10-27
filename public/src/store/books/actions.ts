import { action } from 'typesafe-actions'
import { BooksActionTypes, Book } from './types'

export const loadBooks = (books: Book[]) => action(BooksActionTypes.LOAD, books)
export const addBook = (book: Book) => action(BooksActionTypes.ADD, book)
export const addBookPath = (id: number, path: string) => action(BooksActionTypes.ADD_PATH, { id: id, path: path })
export const deleteBook = (id: number) => action(BooksActionTypes.DELETE, id)
