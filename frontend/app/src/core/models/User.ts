import {Location} from '../../reader/stores/BookReaderStore';

interface LocationMap {
  [key: string]: Location;
}
export interface User {
  fireId: string;
  username: string;
  locations: LocationMap;
}
