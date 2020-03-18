import React, { MutableRefObject, useRef, useState, useEffect, useContext } from "react";
import { Sentence, SelectedWord, SelectedSentence } from "../../models";
import styled, { css } from "styled-components";
import Dict from "./Dict";
import SentenceSelector from "./SetenceSelector";
import { readerContext } from "./Reader";
import { useOutsideClickObserver } from "../../utils/hooks";
const SentenceComponent = styled.p<{ inline: boolean; selected: boolean }>`
  padding: 0;
  margin: 10px 0;
  -webkit-touch-callout: none; /* iOS Safari */
  -webkit-user-select: none;   /* Safari */
  -khtml-user-select: none;    /* Konqueror HTML */
  -moz-user-select: none;      /* Firefox */
  -ms-user-select: none;       /* Internet Explorer/Edge */
  user-select: none;

  ${props =>
    props.inline &&
    css`
      display: inline;
      margin: 0;
    `}
  ${props =>
    props.selected &&
    css`
      display: block;
      background: gray;
      padding: 4px;
      font-weight: 700;
      color: white;
    `}
`;

const WordComponent = styled.span<{ selected: boolean; first: boolean }>`
  display: inline;
  ${props =>
    props.selected &&
    css`
      display: inline;
      background: gray;
      font-weight: 700;
      color: white;
    `}
  ${props =>
    props.first &&
    css`
      margin-left: 4px;
    `}
`;

export const pat = /([^a-zA-Z-']+)/;

interface Props {
  sentences: Sentence[];
}

const SwipeItem: React.FC<Props> = (props: Props) => {
  const readerStore = useContext(readerContext);
  const [selectedWord, setSelectedWord] = useState<SelectedWord | undefined>(undefined);
  const [selectedSentence, setSelectedSentence] = useState<SelectedSentence | undefined>(
    undefined
  );
  const touch: MutableRefObject<
    { id: string; n: number; timer: number; x: number; y: number, el: HTMLElement } | undefined
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
  const onTouchWord = (node: HTMLElement, j: number, k: number, word: string, x: number, y: number) => {
    const id = `${j}-${k}`;
    if (touch.current) {
      setSelectedWord(undefined);
      setSelectedSentence(undefined);
      clearTimeout(touch.current.timer);
      touch.current = undefined;
    }
    const handle = () => {
      if (!touch.current) return;
      if (touch.current.n === 1) {
        setSelectedWord({
          id: `${j}-${k}`,
          word: word,
          sentenceId: sentences[j].id,
          wordIndex: k/2,
          up: figureWordUp(node)
        });
        // window.app.wordSelected(word, Math.floor(k / 2), sentences[j].id);
        setSelectedSentence(undefined);
        touch.current.n = 2;
        touch.current.timer = setTimeout(() => {
          handle();
        }, 800);
      } else if (touch.current.n === 2) {
        setSelectedWord(undefined);
        setSelectedSentence({
          id: j.toString(),
          sentenceId: sentences[j].id,
          top: node.parentElement!.getBoundingClientRect().top,
          bottom: node.parentElement!.getBoundingClientRect().bottom,
          up: figureSentenceUp(node)
        });
        touch.current = undefined;
      }
    };
    const timer = setTimeout(() => {
      handle();
    }, 300);
    touch.current = {
      n: 1,
      timer: timer,
      id: id,
      x: x,
      y: y,
      el: node,
    };
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
      readerStore.onCancel.on(handler);
    }
    return () => {
      if (handler) {
        readerStore.onCancel.off(handler);
      }
    };
  }, [selectedSentence, selectedWord]);

  useEffect(() => {
    const handler = (e) => {
      const x = e.clientX;
      const y = e.clientY;
      if (touch.current && Math.sqrt((x-touch.current.x)**2 + (y-touch.current.y) ** 2) > 30) {
        clearTimeout(touch.current.timer);
      }
    };
    const handler2 = (e) => {
      console.log("Asdfasf");
      if (touch.current) {
        clearTimeout(touch.current.timer);
      }
    };
    let handler3 = undefined;
    if (touch.current) {
      handler3 = (event: any) => {
        if (touch.current.el && !event.target.contains(touch.current.el)) {
          readerStore.onCancel.trigger();
        }
      }
      document.addEventListener("mousedown", handler3);
    }
    document.addEventListener('mouseup', handler2);
    document.addEventListener('mousemove', handler);
    return () => {
      document.removeEventListener('mouseup', handler2);
      document.removeEventListener('mousemove', handler);
      if (handler3) {
        document.removeEventListener("mousedown", handler3);
      }
    };
  })

  const { sentences } = props;

  return (
    <>
      {
        selectedWord &&
        <Dict selectedWord={selectedWord}></Dict>
      }
      {
        selectedSentence &&
        <SentenceSelector selectedSentence={selectedSentence}></SentenceSelector>
      }
      {sentences.map((sentence, j) => (
        <SentenceComponent
          selected={selectedSentence ? selectedSentence.id === j.toString() : false}
          inline={!sentence.start || sentence.content.trim() === '.'}
          key={j}
        >
          {sentence.content.split(pat).filter(s => s.length !== 0).map((word: string, k: number) => (
            <WordComponent
              selected={ selectedWord ? selectedWord.id === `${j}-${k}` : false}
              first={k===0}
              key={k}
              onTouchEnd={() => {
                if (touch.current) {
                  clearTimeout(touch.current.timer);
                }
              }}
              onTouchMove={(e) => {
                if (e.touches.length !== 1) {
                  return;
                }
                const x = e.touches[0].clientX;
                const y = e.touches[0].clientY;
                if (touch.current && Math.sqrt((x-touch.current.x)**2 + (y-touch.current.y) ** 2) > 30) {
                  clearTimeout(touch.current.timer);
                }
              }}

              onTouchCancel={(e) => {
                if (touch.current) {
                  clearTimeout(touch.current.timer);
                }
              }}

              onTouchStart={
                !word.match(pat)
                  ? (e) => {
                      if (e.touches.length !== 1) {
                        if (touch.current) {
                          clearTimeout(touch.current.timer);
                        }
                        return;
                      }
                      onTouchWord(e.target as HTMLElement, j, k, word, e.touches[0].clientX, e.touches[0].clientY);
                    }
                  : undefined
              }

              onMouseDown={
                !word.match(pat)
                  ? (e) => {
                      if (touch.current) {
                        clearTimeout(touch.current.timer);
                        touch.current = undefined;
                      }
                      onTouchWord(e.target as HTMLElement, j, k, word, e.clientX, e.clientY);
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
