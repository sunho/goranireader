import React, { MutableRefObject, useRef, useState, useEffect } from "react";
import "./SwipeItem.css"
import { Sentence } from "./model";
import { useLiteEventObserver } from "./hooks";

interface Props {
  sentences: Sentence[];
}

const SwipeItem: React.FC<Props> = (props: Props) => {
  const [selectedWord, setSelectedWord]: [any, any] = useState(undefined);
  const [selectedSentence, setSelectedSentence]: [any, any] = useState(
    undefined
  );
  const pat = /([\s])/;
  const touch: MutableRefObject<
    { id: string; n: number; timer: NodeJS.Timeout } | undefined
  > = useRef(undefined);
  const onTouchWord = (j: number, k: number, word: string) => {
    const id = `${j}-${k}`;
    const timer = setTimeout(() => {
      touch.current = undefined;
    }, 300);
    if (touch.current && touch.current.id === id) {
      clearTimeout(touch.current.timer);
      touch.current.timer = timer;
      touch.current.n++;
    } else {
      touch.current = {
        id: id,
        timer: timer,
        n: 1
      };
    }
    if (touch.current.n === 2) {
      setSelectedWord(id);
      window.app.wordSelected(k/2, sentences[j].id);
      setSelectedSentence(undefined);
    } else if( touch.current.n === 3) {
      setSelectedWord(undefined);
      setSelectedSentence(`${j}`);
      window.app.sentenceSelected(sentences[j].id);
    } else {
      setSelectedWord(undefined);
      setSelectedSentence(undefined);
    }
  };

  useEffect(() => {
    let handler: any;
    if (selectedWord) {
      handler = () => {
        setSelectedWord(undefined)
      }
    } else if (selectedSentence) {
      handler = () => {
        setSelectedSentence(undefined)
      }
    }

    if (handler) {
      window.webapp.onCancelSelect.on(handler);
    }
    return () => {
      if (handler) {
        window.webapp.onCancelSelect.off(handler);
      }
    }
  }, [selectedSentence, selectedWord]);

  const { sentences } = props;

  return (
    <>
      {sentences.map((sentence, j) => (
        <p className={selectedSentence === j.toString()?"SelectedSentence":undefined}key={j}>
          {sentence.content.split(pat).map((word: string, k: number) => (
            <span
              key={k}
              className={selectedWord === `${j}-${k}`?"SelectedWord":undefined}
              onClick={!word.match(pat)?() => {
                onTouchWord(j, k, word);
              }:undefined}
            >
              {word}
            </span>
          ))}
        </p>
      ))}
    </>
  );
};

export default SwipeItem;
