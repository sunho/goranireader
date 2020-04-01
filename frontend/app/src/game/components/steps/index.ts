import { Review, StepKind } from "../../models/Game";
import { registerStepComponent } from "../StepperContainer";
import StatsReviewStepComponent from "./StatsReviewStepComponent";
import LWReviewStepComponent from "./LWReviewStepComponent";
import UWReviewStepComponent from './UWReviewStepComponent';

export function register() {
  registerStepComponent(StepKind.StatsReview, StatsReviewStepComponent);
  registerStepComponent(StepKind.LWReview, LWReviewStepComponent);
  registerStepComponent(StepKind.UWReview, UWReviewStepComponent);
}
