import { Review, StepKind } from "../../models/Game";
import { registerStepComponent } from "../StepperContainer";
import StatsReviewStep from "./StatsReviewStep";
import LastWordsReviewStep from "./LastWordsReviewStep";
import UnfamiliarWordsReviewStep from './UnfamiliarWordsReviewStep';

export function register() {
  registerStepComponent(StepKind.StatsReview, StatsReviewStep);
  registerStepComponent(StepKind.LastWordsReview, LastWordsReviewStep);
  registerStepComponent(StepKind.UnfamiliarWordsReview, UnfamiliarWordsReviewStep);
}
