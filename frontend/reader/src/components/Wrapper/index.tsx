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
  useLiteEventObserver(
    window.webapp.onStartQuiz,
    (event: any) => {
      setState(null);
      setState({
        type: 'quiz',
        questions: event.questions,
        qid: event.qid
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
            "   .   ",
          start: true
        }));
      // window.webapp.startReader(data, "50");
      window.webapp.startQuiz([{
        type: 'word',
        sentence: 'hehello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldhello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello worldllo world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world',
        wordIndex: 1,
        options: ['hihi', 'hoho'],
        answer: 0,
        id: '1'
      },{
        type: 'word',
        sentence: 'hello world',
        wordIndex: 1,
        options: ['hihi', 'hoho'],
        answer: 0,
        id: '2'
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
