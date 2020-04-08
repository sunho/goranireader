
export interface Migration {
  version: number;
  name: string;
  migrate?(model: any): any;
  default?(): any;
}

export class Migrator {
  migrations: Migration[];
  constructor(migrations: Migration[]) {
    this.migrations = migrations;
  }

  migrate(model: any) {
    let version = 0;
    if (!model.version) {
      version = 0;
    } else {
      version = model.version;
    }
    let i = this.migrations.findIndex(x => (x.version === version)) + 1;
    for (; i < this.migrations.length; i ++) {
      if (this.migrations[i].migrate) {
        model = this.migrations[i].migrate!(model);
      }
    }
    return model;
  }

  default() {
    return this.migrations[this.migrations.length - 1].default!()
  }
}
