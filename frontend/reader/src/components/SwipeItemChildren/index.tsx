import React, { MutableRefObject, useRef, useState, useEffect } from "react";
import { Sentence, SelectedWord, SelectedSentence } from "../../model";
import styled, { css } from "styled-components";
import Dict from "../Dict";

const SentenceComponent = styled.p<{ inline: boolean; selected: boolean }>`
  padding: 0;
  margin: 10px 0;

  ${props =>
    !props.inline &&
    css`
      display: inline;
      margin: 0;
    `}
  ${props =>
    props.selected &&
    css`
      background: black;
    `}
`;

const WordComponent = styled.span<{ selected: boolean }>`
  ${props =>
    props.selected &&
    css`
      background: red;
    `}
`;

interface Props {
  sentences: Sentence[];
}

const SwipeItem: React.FC<Props> = (props: Props) => {
  const [selectedWord, setSelectedWord] = useState<SelectedWord | undefined>(undefined);
  const [selectedSentence, setSelectedSentence] = useState<SelectedSentence | undefined>(
    undefined
  );
  const pat = /([\s])/;
  const touch: MutableRefObject<
    { id: string; n: number; timer: number } | undefined
  > = useRef(undefined);
  const figureSentenceUp = (word: HTMLElement) => {
    const parentRect = word.parentElement!.parentElement!.getBoundingClientRect();
    const myRect = word.parentElement!.getBoundingClientRect();
    return (parentRect.top - myRect.top) ** 2 > (myRect.bottom - parentRect.bottom) ** 2
  }
  const figureWordUp = (word: HTMLElement) => {
    const parentRect = word.parentElement!.parentElement!.getBoundingClientRect();
    const myRect = word.getBoundingClientRect();
    return (parentRect.top - myRect.top) ** 2 > (myRect.bottom - parentRect.bottom) ** 2
  }
  const onTouchWord = (node: HTMLElement, j: number, k: number, word: string) => {
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
      setSelectedWord({
        id: `${j}-${k}`,
        word: word,
        sentenceId: sentences[j].id,
        wordIndex: k/2,
        up: figureWordUp(node)
      });
      window.app.wordSelected(k / 2, sentences[j].id);
      setSelectedSentence(undefined);
    } else if (touch.current.n === 3) {
      setSelectedWord(undefined);
      setSelectedSentence({
        id: j.toString(),
        sentenceId: sentences[j].id,
        top: node.getBoundingClientRect().top,
        bottom: node.getBoundingClientRect().bottom,
        up: figureSentenceUp(node)
      });
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
        setSelectedWord(undefined);
      };
    } else if (selectedSentence) {
      handler = () => {
        setSelectedSentence(undefined);
      };
    }

    if (handler) {
      window.webapp.onCancelSelect.on(handler);
    }
    return () => {
      if (handler) {
        window.webapp.onCancelSelect.off(handler);
      }
    };
  }, [selectedSentence, selectedWord]);

  const { sentences } = props;

  return (
    <>
      {sentences.map((sentence, j) => (
        <SentenceComponent
          selected={selectedSentence ? selectedSentence.id === j.toString() : false}
          inline={!sentence.start}
          key={j}
        >
          {sentence.content.split(pat).map((word: string, k: number) => (
            <WordComponent
              selected={ selectedWord ? selectedWord.id === `${j}-${k}` : false}
              key={k}
              onClick={
                !word.match(pat)
                  ? (e) => {
                      onTouchWord(e.target as HTMLElement, j, k, word);
                    }
                  : undefined
              }
            >
              {word}
            </WordComponent>
          ))}
        </SentenceComponent>
      ))}
    </>
  );
};

export default SwipeItem;
