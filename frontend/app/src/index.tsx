import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import * as serviceWorker from './serviceWorker';
import StoreProvider from './core/stores/Context';
import { isPlatform, getPlatforms } from '@ionic/react';
import {logo, text, version} from './gorani';
ReactDOM.render(<StoreProvider><App /></StoreProvider>, document.getElementById('root'));

serviceWorker.unregister();
console.log(logo);
console.log("Gorani Reader " + version);
console.log("Your platform:", getPlatforms().join(','));
