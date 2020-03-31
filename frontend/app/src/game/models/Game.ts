import { Sentence, Item } from "../../core/models";
export interface Review {
  time: string;
  stats: Stats;
  lastWords: LastWord[];
  targetLastWords: number;
  unfamiliarWords: UnfamiliarWord[];
  targetUnfamiliarWords: number;
  texts: Text[];
}

export interface Progress {
  step: number;
  steps: Step[];
  review: Review;
}

export function generateProgress(review: Review): Progress {
  return {
    step: 0,
    review: review,
    steps: [
      {
        kind: StepKind.UnfamiliarWordsReview,
      },
      {
        kind: StepKind.StatsReview
      },
    ]
  }
}

export type Step = StatsReviewStep | LastWordsReviewStep | UnfamiliarWordsReview;

export interface GameStep {
  completed: number;
  target: number;
}

export interface StatsReviewStep {
  kind: StepKind.StatsReview,
}

export interface LastWordsReviewStep {
  kind: StepKind.LastWordsReview,
}

export interface UnfamiliarWordsReview {
  kind: StepKind.UnfamiliarWordsReview,
}

export enum StepKind {
  StatsReview = 1,
  LastWordsReview = 2,
  UnfamiliarWordsReview = 3,
  Finalize = 4
}

export interface Stats {
  lastReadWords: Datapoint[];
  wpm: Datapoint[];
  hours: Datapoint[];
  // preparedness
}

interface Datapoint {
  time: string;
  y: number;
}

export interface LastWord {
  word: string;
  sid: string;
  sentences: Sentence[];
}

export interface Text {
  unfamiliarWords: string[];
  content: Item[];
}

export interface UnfamiliarWord {
  word: string;
  texts: number[];
}
