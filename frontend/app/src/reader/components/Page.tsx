import React, {
  MutableRefObject,
  useRef,
  useState,
  useEffect,
  useContext,
  forwardRef
} from "react";
import {
  Sentence,
  SelectedWord,
  SelectedSentence,
  Item
} from "../../core/models";
import styled, { css } from "styled-components";
import Dict from "./Dict";
import SentenceSelector from "./SetenceSelector";

import { useOutsideClickObserver } from "../../core/utils/hooks";
import { isPlatform } from "@ionic/react";
import { ReaderContext } from "../stores/ReaderRootStore";
import { useObserver } from "mobx-react";
const SentenceComponent = styled.p<{ inline: boolean; selected: boolean }>`
  padding: 0;
  margin: 10px 0;
  -webkit-touch-callout: none; /* iOS Safari */
  -webkit-user-select: none; /* Safari */
  -khtml-user-select: none; /* Konqueror HTML */
  -moz-user-select: none; /* Firefox */
  -ms-user-select: none; /* Internet Explorer/Edge */
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

const WordComponent = styled.span<{
  selected: boolean;
  first: boolean;
  enabled: boolean;
  highlight: boolean;
}>`
  display: inline;

  ${props =>
    props.highlight &&
    css`
      display: inline;
      background: orange;
      font-weight: 700;
      color: white;
    `}

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

interface Props2 {
  image: string;
  imageType: string;
}

const ImageComponet: React.FC<Props2> = props => (
  <img
    style={{ display: "block", maxHeight: "100%", objectFit: "contain" }}
    src={`data:${props.imageType};base64, ${props.image}`}
  ></img>
);

export const pat = /([^a-zA-Z-']+)/;

interface Props {
  sentences: Item[];
  hightlightWord?: string[];
}

const Page = forwardRef<HTMLDivElement, Props>((props, ref) => {
  const readerRootStore = useContext(ReaderContext)!;
  const { readerUIStore } = readerRootStore;
  const touch: MutableRefObject<
    | {
        id: string;
        n: number;
        timer: ReturnType<typeof setTimeout>;
        x: number;
        y: number;
        el: HTMLElement;
      }
    | undefined
  > = useRef(undefined);
  const figureWordUp = (word: HTMLElement) => {
    const parentRect = word.parentElement!.parentElement!.getBoundingClientRect();
    const myRect = word.getBoundingClientRect();
    return (
      (parentRect.top - myRect.top) ** 2 >
      (myRect.bottom - parentRect.bottom) ** 2
    );
  };
  const onTouchWord = (
    node: HTMLElement,
    j: number,
    k: number,
    word: string,
    x: number,
    y: number
  ) => {
    const id = `${j}-${k}`;
    if (touch.current) {
      readerUIStore.selectedWord = undefined;
      clearTimeout(touch.current.timer);
      touch.current = undefined;
    }
    const handle = () => {
      if (!touch.current) return;
      readerUIStore.selectWord(word, Math.floor(k / 2), sentences[j].id);
      readerUIStore.selectedWord = {
        id: `${j}-${k}`,
        word: word,
        sentenceId: sentences[j].id,
        wordIndex: k / 2,
        up: figureWordUp(node)
      };
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
      el: node
    };
  };

  useEffect(() => {
    const handler = (e: any) => {
      const x = e.clientX;
      const y = e.clientY;
      if (
        touch.current &&
        Math.sqrt((x - touch.current.x) ** 2 + (y - touch.current.y) ** 2) > 30
      ) {
        clearTimeout(touch.current.timer);
      }
    };
    const handler2 = () => {
      if (touch.current) {
        clearTimeout(touch.current.timer);
      }
    };
    document.addEventListener("mouseup", handler2);
    document.addEventListener("mousemove", handler);
    return () => {
      document.removeEventListener("mouseup", handler2);
      document.removeEventListener("mousemove", handler);
    };
  });

  const { sentences } = props;

  return useObserver(() => (
    <div
      className="swiper-slide"
      style={{
        cursor: !isPlatform("desktop") ? "pointer" : undefined,
        padding: isPlatform("desktop") ? "0 70px" : undefined
      }}
      ref={ref}
    >
      {sentences.map((sentence, j) =>
        sentence.kind === "image" ? (
          <ImageComponet
            image={sentence.image}
            imageType={sentence.imageType}
          ></ImageComponet>
        ) : (
          <SentenceComponent
            selected={false}
            inline={!sentence.start || sentence.content.trim() === "."}
            key={j}
          >
            {sentence.content
              .split(pat)
              .filter(s => s.length !== 0)
              .map((word: string, k: number) => (
                <WordComponent
                  selected={
                    readerUIStore.selectedWord
                      ? readerUIStore.selectedWord.id === `${j}-${k}`
                      : false
                  }
                  first={k === 0}
                  key={k}
                  highlight={
                    props.hightlightWord
                      ? props.hightlightWord.map(x=>x.toLowerCase()).includes(word.toLowerCase())
                      : false
                  }
                  onTouchEnd={() => {
                    if (touch.current) {
                      clearTimeout(touch.current.timer);
                    }
                  }}
                  onTouchMove={e => {
                    if (e.touches.length !== 1) {
                      return;
                    }
                    const x = e.touches[0].clientX;
                    const y = e.touches[0].clientY;
                    if (
                      touch.current &&
                      Math.sqrt(
                        (x - touch.current.x) ** 2 + (y - touch.current.y) ** 2
                      ) > 30
                    ) {
                      clearTimeout(touch.current.timer);
                    }
                  }}
                  onTouchCancel={e => {
                    if (touch.current) {
                      clearTimeout(touch.current.timer);
                    }
                  }}
                  enabled={word.match(pat) !== null}
                  onTouchStart={
                    !word.match(pat)
                      ? e => {
                          if (e.touches.length !== 1) {
                            if (touch.current) {
                              clearTimeout(touch.current.timer);
                            }
                            return;
                          }
                          onTouchWord(
                            e.target as HTMLElement,
                            j,
                            k,
                            word,
                            e.touches[0].clientX,
                            e.touches[0].clientY
                          );
                        }
                      : undefined
                  }
                  onMouseDown={
                    !word.match(pat)
                      ? e => {
                          if (touch.current) {
                            clearTimeout(touch.current.timer);
                            touch.current = undefined;
                          }
                          onTouchWord(
                            e.target as HTMLElement,
                            j,
                            k,
                            word,
                            e.clientX,
                            e.clientY
                          );
                        }
                      : undefined
                  }
                >
                  {word}
                </WordComponent>
              ))}
          </SentenceComponent>
        )
      )}
    </div>
  ));
});

export default Page;
