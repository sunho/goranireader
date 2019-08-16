import "react-app-polyfill/stable";
import "./index.css";
import { Webapp } from "./bridge";
import App from "./App";
import React, { useState, useEffect } from "react";
import { useLiteEventObserver } from "./hooks";
import ReactDOM from "react-dom";

window.webapp = new Webapp();
if (process.env.NODE_ENV === "development") {
  window.webapp.setDev();
}

const Wrapper: React.SFC = () => {
  const [tmp, setTmp]: [any, any] = useState({ sentences: [{content: "loading", id:"0", start: true}], sid: "" });
  useLiteEventObserver(
    window.webapp.onStart,
    (event: any) => {
      console.log("Asdf");
      setTmp({
        sentences: event.sentences,
        sid: event.sid
      });
    },
    [setTmp]
  );
  useEffect(() => {
    window.app.initComplete();
    if (process.env.NODE_ENV === "development") {
      const data = Array(100)
        .fill(1)
        .map((x, y) => x + y)
        .map(id => ({
          id: id.toString(),
          content:
            "afdasf asdf safasdf safasd sadf asdfasf sadf asdfsa fsadf sadf sadfasfsadf sad fasdf adsf asdf asdf safsd afsa fsfasd fasf sad",
          start: true
        }));
      window.webapp.start(data, "");
    }
  }, []);
  return <App sentences={tmp.sentences} readingSentence={tmp.sid} />;
};

ReactDOM.render(<Wrapper />, document.getElementById("root"));
