import { Sentence, Item } from "../../core/models";
export interface Review {
  time: string;
  stats: Stats;
  lastWords: LastWord[];
  targetLastWords: number;
  unfamiliarWords: UnfamiliarWord[];
  targetCompletedTexts: number;
  texts: Text[];
}

export interface Progress {
  step: number;
  steps: Step[];
  review: Review;
  savedata: { [step: number]: object };
}

export function generateProgress(review: Review): Progress {
  return {
    step: 0,
    review: review,
    steps: [
      {
        kind: StepKind.LWReview,
      },
      {
        kind: StepKind.UWReview,
      },
      {
        kind: StepKind.StatsReview
      },
    ],
    savedata: {}
  }
}

export type Step = StatsReviewStep | LWReviewStep | UWReviewStep;

export interface GameStep {
  completed: number;
  target: number;
}

export interface StatsReviewStep {
  kind: StepKind.StatsReview,
}

export interface LWReviewStep {
  kind: StepKind.LWReview,
}

export interface UWReviewStep {
  kind: StepKind.UWReview,
}

export enum StepKind {
  StatsReview = 1,
  LWReview = 2,
  UWReview = 3,
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
