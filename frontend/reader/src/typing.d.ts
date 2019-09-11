import { Webapp, App } from "./bridge";

declare global {
    interface Window {
        app: App
        webapp: Webapp
        webkit: any
    }
}

window.app = window.app || {};
window.webapp = window.webapp || {};
