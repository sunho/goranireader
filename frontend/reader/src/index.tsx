import 'react-app-polyfill/stable';
import './index.css';
import { Webapp } from './bridge';


window.webapp = new Webapp();
if (process.env.NODE_ENV === "development") {
    window.webapp.setDev();
}
window.app.initComplete();
if (process.env.NODE_ENV === "development") {
  const data = Array(100).fill(1).map((x,y) => x+y).map(id => ({
    id: id.toString(),
    content: "afdasf asdf safasdf safasd sadf asdfasf sadf asdfsa fsadf sadf sadfasfsadf sad fasdf adsf asdf asdf safsd afsa fsfasd fasf sad",
    start: true,
  }));
  window.webapp.start(JSON.stringify(data), "")
}
