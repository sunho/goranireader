import { DownloadsState, DownloadsActionTypes } from "./types";
import { Reducer, Action } from "redux";

const initialState: DownloadsState = {
  data: {}
}

export const donwloadsReducer: Reducer<DownloadsState> = (state = initialState, action) => {
  switch(action.type) {
    case DownloadsActionTypes.ADD: {
      return {
        data: {
          ...state.data,
          [action.payload.id]: action.payload
        }
      }
    }
    case DownloadsActionTypes.PROGRESS: {
      return {
        data: {
          ...state.data,
          [action.payload.id]: {
            ...state.data[action.payload.id],
            percent: action.payload.percent
          }
        }
      }
    }
    case DownloadsActionTypes.REMOVE: {
      return {
        data: {
          [action.payload]: undefined, ...state.data
        }
      }
    }
    default: {
      return state
    }
  }
  return state
}
