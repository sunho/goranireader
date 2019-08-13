export interface App {
    initComplete(): void;
    loadComplete(used: string): void;
};

export interface Webapp {
    setDev(): void;
    setIOS(): void;
    load(buf: string): void;
};

export class WebappImpl {
    constructor() {

    }

    setDev() {
        window.app = new DevAppImpl();
    }

    setIOS() {
    }

    load(buf: string) {
    }
}

class DevAppImpl {
    constructor() {

    }

    initComplete() {
        console.log('[app] init complete');
    }

    loadComplete(used: string) {
        console.log('[app] loadComplete used:' + used);
    }
}
