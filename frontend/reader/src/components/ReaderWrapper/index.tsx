import { useLiteEventObserver } from "../../utills/hooks";
import { useState, useEffect } from "react";
import React from "react";
import Reader from "../Reader";

const ReaderWrapper: React.SFC = () => {
  const [tmp, setTmp]: [any, any] = useState({ sentences: [{content: "loading", id:"0", start: true}], sid: "" });
  useLiteEventObserver(
    window.webapp.onStart,
    (event: any) => {
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
            "afdasf asdf safasdf, safasd! (sadf asdfasf, sadf) asdfsa fsadf sadf sadfasfsadf sad fasdf adsf asdf asdf safsd afsa fsfasd fasf sad",
          start: false
        }));
      window.webapp.start(data, "50");
    }
  }, []);
  return <Reader sentences={tmp.sentences} readingSentence={tmp.sid} />;
};

export default ReaderWrapper;
