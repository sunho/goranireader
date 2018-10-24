export enum BooksActionTypes {
  LOAD = '[book] LOAD',
  ADD = '[book] ADD',
  DELETE = '[book] DELETE',
}

export interface Book {
  id: number
  name: string
  src: string
  path?: string
  cover: string
  author: string
}

export interface BooksState {
  readonly syncTimestamp: number;
  readonly data: Book[]
}
