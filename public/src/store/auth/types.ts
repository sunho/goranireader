export enum AuthActionTypes {
  REQUEST = '[auth] REQUEST',
  SUCCESS = '[auth] SUCCESS',
  FAIL = '[auth] FAIL',
}

export interface User {
  name: string
  token: string
}

export interface AuthState {
  readonly request: boolean;
  readonly logined: boolean;
  readonly user?: User
}
