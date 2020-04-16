import { Sentence, Item } from "../../core/models";
export interface Review {
  id: string;
  start: number;
  end: number;
  stats?: Stats;
  reviewWords: LastWord[];
  targetReviewWords : number;
}

export interface Progress {
  step: number;
  steps: Step[];
  review: Review;
  savedata: { [step: string]: object };
}

export function generateProgress(review: Review): Progress {
  const steps: Step[] = [];
  if (review.stats) {
    steps.push({
      kind: StepKind.StatsReview
    });
  }
  if (review.reviewWords.length !== 0) {
    steps.push({
      kind: StepKind.LWReview
    });
  }
  return {
    step: 0,
    review: review,
    steps: steps,
    savedata: {}
  };
}

export type Step = StatsReviewStep | LWReviewStep;

export interface GameStep {
  completed: number;
  target: number;
}

export interface StatsReviewStep {
  kind: StepKind.StatsReview;
}

export interface LWReviewStep {
  kind: StepKind.LWReview;
}

export enum StepKind {
  StatsReview = 1,
  LWReview = 2,
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

