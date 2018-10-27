import { Reducer } from 'redux'
import { BooksState, BooksActionTypes } from './types';

const initialState: BooksState = {
  syncTimestamp: 0,
  data: [
    {
      id: 32414,
      name: 'asdfasf',
      cover: 'asdffs',
      src: 'https://s3-us-west-2.amazonaws.com/pressbooks-samplefiles/MetamorphosisJacksonTheme/Metamorphosis-jackson.epub',
      author: 'asdfasfd'
    },
    {
      id: 3244,
      name: 'asdfasf',
      cover: 'https://images-na.ssl-images-amazon.com/images/I/61GPmyCxTpL._SX331_BO1,204,203,200_.jpg',
      src: 'https://s3-us-west-2.amazonaws.com/pressbooks-samplefiles/MetamorphosisJacksonTheme/Metamorphosis-jackson.epub',
      author: 'asdfasfd'
    }
  ]
}

export const booksReducer: Reducer<BooksState> = (state = initialState, action) => {
  switch(action.type) {
    case BooksActionTypes.ADD: {
      return {
        ...state,
        data: state.data.find(b => b.id === action.payload.id) ?
        state.data: state.data.concat(action.payload)
      }
    }
    case BooksActionTypes.DELETE: {
      return {
        ...state,
        data: state.data.filter(b => b.id !== action.payload)
      }
    }
    case BooksActionTypes.ADD_PATH: {
      const book = state.data.find(b => b.id === action.payload.id)
      book.path = action.payload.path
      return {
        ...state,
        data: book ? state.data.filter(b => b.id !== book.id).concat(book) : state.data
      }
    }
    case BooksActionTypes.LOAD: {
      return { ...state, data: action.payload }
    }
    default: {
      return state
    }
  }
}
