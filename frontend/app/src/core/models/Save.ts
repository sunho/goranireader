import { Progress } from "../../game/models/Game";

export interface Save {
  version: number;
  progress?: Progress;
}
