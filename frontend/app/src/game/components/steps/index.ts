import { StepKind } from "../../models/Game";
import { registerStepComponent } from "../StepperContainer";
import StatsReviewStepComponent from "./StatsReviewStepComponent";
import LWReviewStepComponent from "./LWReviewStepComponent";

export function register() {
  registerStepComponent(StepKind.StatsReview, StatsReviewStepComponent);
  registerStepComponent(StepKind.LWReview, LWReviewStepComponent);
}
