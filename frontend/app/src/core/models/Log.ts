export interface EventLog {
  id: string;
  type: string;
  time: string;
  payload: string;
}

export type EventLogPayload = LogPaginatePayload |
  LogReviewStartPayload | LogReviewPaginatePayload |
  LogLWReviewNextPayload | LogLWReviewGiveupPayload |
  LogLWReviewCompletePayload | LogReviewEndPayload;

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

export interface LogReviewStartPayload {
  type: 'review-start';
  reviewId: string;
  step: Step;
}

export interface LogReviewPaginatePayload {
  type: 'review-paginate';
  reviewId: string;
  step: Step;
  time: number;
  sids: string[];
  targetWords: string[];
  content: string[];
  wordUnknowns: PaginateWordUnknown[];
}

export interface LogLWReviewNextPayload {
  type: 'last-words-review-next';
  reviewId: string;
  visibleWords: string[];
  selectedWords: string[];
  time: number;
  words: string[];
  previousCompletedWords: number;
  targetCompletedWords: number;
}

export interface LogLWReviewGiveupPayload {
  type: 'last-words-review-giveup';
  reviewId: string;
  time: number;
  words: string[];
  completedWords: number;
  targetCompletedWords: number;
}

export interface LogLWReviewCompletePayload {
  type: 'last-words-review-complete';
  reviewId: string;
  time: number;
  words: string[];
  completedWords: number;
  targetCompletedWords: number;
}

export interface LogReviewEndPayload {
  type: 'review-end';
  reviewId: string;
}

type Step = 'last-words' | 'unfamiliar-words';
