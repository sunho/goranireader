export interface EventLog {
  id: string;
  type: string;
  time: string;
  payload: string;
}

export type EventLogPayload = LogPaginatePayload;

export interface LogPaginatePayload {
  type: 'paginate';
  bookId: string;
  chapterId: string;
  time: number;
  sids: string[];
  wordUnknowns: PaginateWordUnknown[];
  sentenceUnknowns: PaginateSentenceUnknown[];
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
