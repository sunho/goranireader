import { Migration, Migrator } from ".";
import { Review } from "../../../game/models/Game";

interface LocationMap {
  [key: string]: Location;
}
interface V0User {
  fireId: string;
  username: string;
  version?: number;
  locations?: LocationMap;
  review?: string | Review;
  lastReviewEnd?: number;
}

interface V1User {
  version: number;
  fireId: string;
  username: string;
  locations: LocationMap;
  review?: string | Review;
  lastReviewEnd?: number;
}


const migrations: Migration[] = [
  {
    name: 'initial',
    version: 1,
    migrate: (model: V0User) => {
      if (!model.version) {
        model.version = 1;
      }
      if (!model.locations) {
        model.locations = {};
      }
      return model as V1User;
    }
  }
]

export default new Migrator(migrations);
