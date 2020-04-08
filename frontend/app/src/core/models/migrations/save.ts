import { Progress } from "../../../game/models/Game";
import { Migration, Migrator } from ".";

interface V1Save {
  version: number;
  progress?: Progress;
}

const migrations: Migration[] = [
  {
    name: 'initial',
    version: 1,
    default: () => ({
      version: 1,
    }),
    migrate: (model: any) => {
      model.version = 1;
      return model; 
    }
  }
]

export default new Migrator(migrations);
