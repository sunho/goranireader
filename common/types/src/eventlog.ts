
/** 이벤트 로그를 나타냅니다. */
interface EventLog {
  /** uuid형태 입니다. */
  userId: string;
  /** 로그가 작성된 시각입니다. rfc3339형태 입니다. */
  time: string;
  /** 이벤트 로그의 실질적인 정보를 담고 있습니다. */
  payload: EventLogPayload;
}

/** 이벤트 로그의 실질적인 정보를 담고 있습니다. */
type EventLogPayload = LogPaginatePayload |
  LogReviewStartPayload | LogReviewPaginatePayload |
  LogLWReviewNextPayload | LogLWReviewGiveupPayload |
  LogLWReviewCompletePayload | LogReviewEndPayload |
  LogActivePayload | LogActivePayload | LogDeactivePayload;

/**
 * 사용자가 페이지를 앞이나 뒤로 넘겼을 때 전송됩니다.
 */
interface LogPaginatePayload {
  type: 'paginate';
  bookId: string;
  chapterId: string;
  /** 해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다. */
  time: number;
  /** 해당 페이지에 있엇던 문장들의 아이디입니다. */
  sentenceIds: string[];
  /** 본문에 있는 문장들의 배열입니다. */
  content: string[];
  /** 해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다. */
  wordUnknowns: PaginateWordUnknown[];
}

/** 찾아봤던 단어에 대한 정보를 담고 있습니다. */
interface PaginateWordUnknown {
  sentenceId: string;
  word: string;
  /** 해당 문장을 아래 정규식을 기준으로 split했을 때 찾아본 단어가 몇번째인지 나타냅니다.
   * ```
   * /([^a-zA-Z-']+)/
   * ```
  */
  wordIndex: number;
  /** 페이지 시작후로부터 경과한 시간입니다. 단위는 ms입니다. */
  time: number;
}

/** 사용자가 특정 페이지에 들어왔을 때 전송됩니다. */
interface LogActivePayload {
  type: 'active';
  page: string;
}

/** 사용자가 특정 페이지에서 나갔을 때 전송됩니다. */
interface LogDeactivePayload {
  type: 'deactive';
  page: string;
}

/** 사용자가 리뷰게임을 시작했을 때 전송됩니다. */
interface LogReviewStartPayload {
  type: 'review-start';
  reviewId: string;
  step: Step;
}

/** 사용자가 리뷰게임의 리더에서 페이지를 넘겼을 때 전송됩니다. */
interface LogReviewPaginatePayload {
  type: 'review-paginate';
  reviewId: string;
  step: Step;
  /** 해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다. */
  time: number;
  sentenceIds: string[];
  /** 해당 텍스트에서 습득해야할 목표 단어입니다. */
  targetWords: string[];
  /** 본문에 있는 문장들의 배열입니다. */
  content: string[];
  /** 해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다. */
  wordUnknowns: PaginateWordUnknown[];
}

/** 사용자가 리뷰게임에서 페이지의 단어들을 다 리뷰하고 다음으로 넘어갈 때 전송됩니다. */
interface LogLWReviewNextPayload {
  type: 'review-words-review-next';
  reviewId: string;
  /** 사용자가 선택할 수 있엇던 단어들입니다. */
  visibleWords: string[];
  /** 사용자가 선택한 단어들입니다. */
  selectedWords: string[];
  /** 페이지가 나타나고부터 경과한 시간 */
  time: number;
  /** 해당 리뷰게임에 포함된 목표 단어들입니다. */
  words: string[];
  /** 전까지 복습한 단어의 수 */
  previousCompletedWords: number;
  /** 목표 복습 단어 수 */
  targetCompletedWords: number;
}

/** 사용자가 리뷰게임을 포기했을 때 발생합니다. */
interface LogLWReviewGiveupPayload {
  type: 'review-words-review-giveup';
  reviewId: string;
  /** 리뷰게임을 시작하고부터 경과한 시간. */
  time: number;
  /** 목표 습득 단어들 */
  words: string[];
  /** 복습한 단어의 수 */
  completedWords: number;
  /** 목표 복습 단어 수 */
  targetCompletedWords: number;
}

/** 사용자가 리뷰게임의 목표 복습 단어수 이상의 단어를 복습하고 완료 버튼을 눌렀을 때 발생합니다. */
interface LogLWReviewCompletePayload {
  type: 'review-words-review-complete';
  reviewId: string;
  /** 리뷰게임을 시작하고부터 경과한 시간. */
  time: number;
  /** 목표 습득 단어들 */
  words: string[];
  /** 복습한 단어의 수 */
  completedWords: number;
  /** 목표 복습 단어 수 */
  targetCompletedWords: number;
}

/** 사용자가 리뷰게임을 종료했을 때 발생합니다. */
interface LogReviewEndPayload {
  type: 'review-end';
  reviewId: string;
}

/** 리뷰 게임의 단계를 나타냅니다 */
type Step = 'review-words';
