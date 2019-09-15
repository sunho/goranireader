import { useLiteEventObserver } from "../../utills/hooks";
import { useState, useEffect } from "react";
import React from "react";
import Reader from "../Reader";
import { Sentence, Question } from "../../model";
import Quiz from "../Quiz";

interface QuizState {
  type: 'quiz';
  qid: string;
  questions: Question[];
}

interface ReaderState {
  type: 'reader';
  sid: string;
  sentences: Sentence[];
}

type State = QuizState | ReaderState;

const Wrapper: React.SFC = () => {
  const [state, setState] = useState<State | null>(null);
  useLiteEventObserver(
    window.webapp.onStartReader,
    (event: any) => {
      setState(null);
      setState({
        type: 'reader',
        sentences: event.sentences,
        sid: event.sid
      });
    },
    []
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
            " \"afdasf asdf safasdf,, safasd! (sadf asdfasf, sadf) asdfsa fsadf sadf sadfasfsadf sad fasdf adsf asdf asdf safsd afsa fsfasd fasf sad",
          start: false
        }));
      // window.webapp.startReader(data, "50");
      window.webapp.startQuiz([{
        type: 'word',
        sentence: 'hello world',
        wordIndex: 1,
        options: ['hihi', 'hoho'],
        answer: 0,
        id: '1'
      }], '')
    }
  }, []);
  let out = <></>;
  if (state) {
    if (state.type === 'reader') {
      out = <Reader sentences={state.sentences} readingSentence={state.sid} />;
    }
    if (state.type === 'quiz') {
      out = <Quiz questions={state.questions} readingQuestion={state.qid} />;
    }
  }
  return out;
};

export default Wrapper;
