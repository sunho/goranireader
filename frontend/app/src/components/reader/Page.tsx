import React, { MutableRefObject, useRef, useState, useEffect, useContext, forwardRef } from "react";
import { Sentence, SelectedWord, SelectedSentence } from "../../models";
import styled, { css } from "styled-components";
import Dict from "./Dict";
import SentenceSelector from "./SetenceSelector";

import { useOutsideClickObserver } from "../../utils/hooks";
import { isPlatform } from "@ionic/react";
import { ReaderContext } from "../../pages/ReaderPage";
const SentenceComponent = styled.p<{ inline: boolean; selected: boolean; font: number }>`
  padding: 0;
  margin: 10px 0;
  -webkit-touch-callout: none; /* iOS Safari */
  -webkit-user-select: none;   /* Safari */
  -khtml-user-select: none;    /* Konqueror HTML */
  -moz-user-select: none;      /* Firefox */
  -ms-user-select: none;       /* Internet Explorer/Edge */
  user-select: none;
  font-size: 1em;
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

const WordComponent = styled.span<{ selected: boolean; first: boolean, enabled: boolean}>`
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
  ${props =>
      props.enabled &&
    css`
      pointer-events: none;
    `}
  &:hover {
    background: lightgray;
  }
`;

export const pat = /([^a-zA-Z-']+)/;

interface Props {
  sentences: Sentence[];
}

const Page = forwardRef<HTMLDivElement, Props>((props, ref) => {
  const readerRootStore = useContext(ReaderContext);
  const { readerUIStore } = readerRootStore;
  const [selectedWord, setSelectedWord] = useState<SelectedWord | undefined>(undefined);
  const touch: MutableRefObject<
    { id: string; n: number; timer:  ReturnType<typeof setTimeout>; x: number; y: number, el: HTMLElement } | undefined
  > = useRef(undefined);
  const figureWordUp = (word: HTMLElement) => {
    const parentRect = word.parentElement!.parentElement!.getBoundingClientRect();
    const myRect = word.getBoundingClientRect();
    return (parentRect.top - myRect.top) ** 2 > (myRect.bottom - parentRect.bottom) ** 2
  }
  const onTouchWord = (node: HTMLElement, j: number, k: number, word: string, x: number, y: number) => {
    const id = `${j}-${k}`;
    if (touch.current) {
      setSelectedWord(undefined);
      clearTimeout(touch.current.timer);
      touch.current = undefined;
    }
    const handle = () => {
      if (!touch.current) return;
      setSelectedWord({
        id: `${j}-${k}`,
        word: word,
        sentenceId: sentences[j].id,
        wordIndex: k/2,
        up: figureWordUp(node)
      });
      readerUIStore.selectWord(word, Math.floor(k / 2), sentences[j].id);
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
    }

    if (handler) {
      readerUIStore.onCancelSelection.on(handler);
    }
    return () => {
      if (handler) {
        readerUIStore.onCancelSelection.off(handler);
      }
    };
  }, [selectedWord]);

  useEffect(() => {
    const handler = (e) => {
      const x = e.clientX;
      const y = e.clientY;
      if (touch.current && Math.sqrt((x-touch.current.x)**2 + (y-touch.current.y) ** 2) > 30) {
        clearTimeout(touch.current.timer);
      }
    };
    const handler2 = () => {
      if (touch.current) {
        clearTimeout(touch.current.timer);
      }
    };
    document.addEventListener('mouseup', handler2);
    document.addEventListener('mousemove', handler);
    return () => {
      document.removeEventListener('mouseup', handler2);
      document.removeEventListener('mousemove', handler);
    };
  })


  const { sentences } = props;

  return (
    <div
      className="swiper-slide"
      style={{cursor: !isPlatform('electron') ? 'pointer':undefined}}
      ref={ref}
    >
      {
        selectedWord &&
        <Dict selectedWord={selectedWord}></Dict>
      }
      {sentences.map((sentence, j) => (
        <SentenceComponent
          selected={false}
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
              enabled={
                word.match(pat) !== null
              }
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
    </div>
  );
});

export default Page;
