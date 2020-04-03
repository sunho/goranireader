import { Sentence, Item } from "../../core/models";
export interface Review {
  id: string;
  start: number;
  end: number;
  stats?: Stats;
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
  const steps: Step[] = [];
  if (review.stats) {
    steps.push({
      kind: StepKind.StatsReview
    })
  }
  if (review.lastWords.length !== 0) {
    steps.push({
      kind: StepKind.LWReview,
    });
  }
  if (review.unfamiliarWords.length !== 0) {
    steps.push({
      kind: StepKind.UWReview,
    });
  }
  return {
    step: 0,
    review: review,
    steps: steps,
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
  items: Item[];
}

export interface Text {
  unfamiliarWords: string[];
  content: Item[];
}

export interface UnfamiliarWord {
  word: string;
  texts: number[];
}
