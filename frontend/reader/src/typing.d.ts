import { Webapp, App } from "./bridge";

declare global {
    interface Window { 
        app: App
        webapp: Webapp
    }
}

window.app = window.app || {};
window.webapp = window.webapp || {};