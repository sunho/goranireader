import { Reducer } from 'redux'
import { BooksState, BooksActionTypes } from './types';

const initialState: BooksState = {
  syncTimestamp: 0,
  data: []
}

export const booksReducder: Reducer<BooksState> = (state = initialState, action) => {
  switch(action.type) {
    case BooksActionTypes.ADD: {
      return {
        ...state,
        books: state.data.find(b => b.id === action.payload.id) ?
        state.data: state.data.concat(action.payload)
      }
    }
    case BooksActionTypes.DELETE: {
      return {
        ...state,
        books: state.data.filter(b => b.id !== action.payload)
      }
    }
    case BooksActionTypes.LOAD: {
      return { ...state, books: action.payload }
    }
    default: {
      return state
    }
  }
}
