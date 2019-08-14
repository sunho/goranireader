import { Sentence } from "./model";

export interface App {
    initComplete(): void;
    loadComplete(used: string): void;
};

export interface Webapp {
    setDev(): void;
    setIOS(): void;
    start(buf: string, sid: string): void;
};

export class WebappImpl {
    constructor() {

    }

    setDev() {
        window.app = new DevAppImpl();
    }

    setIOS() {
    }

    start(buf: string, sid: string) {
        let sentences: Sentence[] = JSON.parse(buf)
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
