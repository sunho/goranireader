import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import * as serviceWorker from './serviceWorker';
import StoreProvider from './stores/Context';
import { isPlatform, getPlatforms } from '@ionic/react';
import {logo, text} from './gorani';
ReactDOM.render(<StoreProvider><App /></StoreProvider>, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
console.log(logo);
console.log("Gorani Reader v1.0.0");
console.log("Your platform:", getPlatforms().join(','));
