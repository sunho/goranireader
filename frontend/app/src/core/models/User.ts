import {Location} from '../../reader/stores/BookReaderStore';
import { Review } from '../../game/models/Game';

interface LocationMap {
  [key: string]: Location;
}
export interface User {
  version: number;
  fireId: string;
  username: string;
  locations: LocationMap;
  review?: Review;
  lastReviewEnd?: number;
}
