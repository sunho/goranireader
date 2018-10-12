export const enum BooksActionTypes {
  ADD = '[book] ADD'
}

export interface Book {
  id: number;
  name: string;
  cover: string;
  author: string;
}

export interface BooksState {
  readonly loading: boolean
  readonly books: Book[]
}
