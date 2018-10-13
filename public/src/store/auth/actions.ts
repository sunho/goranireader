import { action } from 'typesafe-actions'
import { AuthActionTypes, User } from './types'

export const requestAuth = () => action(AuthActionTypes.REQUEST)
export const authSuccess = (user: User) => action(AuthActionTypes.SUCCESS, user)
export const authFail = () => action(AuthActionTypes.FAIL)
