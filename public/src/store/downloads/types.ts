export enum DownloadsActionTypes {
  ADD = '[downloads] ADD',
  PROGRESS = '[downloads] PROGRESS',
  REMOVE = '[downloads] REMOVE'
}

export interface Download {
  id: number
  percent: number
}

export interface DownloadsState {
  data: {[id: number]: Download}
}
