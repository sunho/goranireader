import { BooksState, booksReducer } from "./books";
import { AuthState, authReducer } from "./auth";

import { createStore, Store, combineReducers, Reducer } from 'redux';
import { DownloadsState, donwloadsReducer } from "./downloads";

export interface ApplicationState {
  books: BooksState
  downloads: DownloadsState
  auth: AuthState
}

export const reducers: Reducer<ApplicationState> = combineReducers(
  {
    books: booksReducer,
    downloads: donwloadsReducer,
    auth: authReducer,
  }
)

export function configureStore(): Store<ApplicationState> {
  return createStore(reducers)
}
