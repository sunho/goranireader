export interface Log {
  id: string;
  type: string;
  time: string;
  payload: string;
}

export interface LogPaginatePayload {
  bookId: string;
  chapterId: string;
  time: number;
  sids: string[];

}

export interface PaginateWordUnknown {
  sentenceId: string;
  word: string;
  wordIndex: number;
  time: number;
}

export interface PaginateSentenceUnknown {
  sentenceId: string;
  time: number;
}
