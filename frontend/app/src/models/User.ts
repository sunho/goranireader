import {Location} from '../stores/ReaderStore';

interface LocationMap {
  [key: string]: Location;
}
export interface User {
  fireId: string;
  name: string;
  locations: LocationMap;
}
