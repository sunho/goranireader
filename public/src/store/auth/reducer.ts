import { Reducer } from 'redux'
import { AuthState, AuthActionTypes } from './types';

const initialState: AuthState = {
  request: false,
  logined: false
}

export const authReducer: Reducer<AuthState> = (state = initialState, action) => {
  switch(action.type) {
    case AuthActionTypes.REQUEST: {
      return {
        request: true,
        logined: false
      }
    }
    case AuthActionTypes.SUCCESS: {
      return {
        request: false,
        logined: true,
        user: action.payload
      }
    }
    case AuthActionTypes.FAIL: {
      return {
        request: false,
        logined: false
      }
    }
    default: {
      return state
    }
  }
}
