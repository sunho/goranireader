import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { WebappImpl } from './bridge';

window.webapp = new WebappImpl();
ReactDOM.render(<App />, document.getElementById('root'));
if (process.env.NODE_ENV === "development") {
    window.webapp.setDev();
}
window.app.initComplete();