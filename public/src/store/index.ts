import { BooksState, booksReducder } from "./books";
import { AuthState, authReducder } from "./auth";

import { createStore, Store, combineReducers, Reducer } from 'redux';

export interface ApplicationState {
  books: BooksState
  auth: AuthState
}

export const reducers: Reducer<ApplicationState> = combineReducers(
  {
    books: booksReducder,
    auth: authReducder
  }
)

export function configureStore(): Store<ApplicationState> {
  return createStore(reducers)
}
