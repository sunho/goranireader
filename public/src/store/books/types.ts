export const enum BooksActionTypes {
  LOAD = '[book] LOAD',
  ADD = '[book] ADD',
  DELETE = '[book] DELETE',
}

export interface Book {
  id: number
  name: string
  cover: string
  author: string
}

export interface BooksState {
  readonly syncTimestamp: number;
  readonly books: Book[]
}
