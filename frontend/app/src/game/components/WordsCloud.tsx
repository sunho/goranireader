import React, { useContext, useState, useRef, useEffect } from "react";
import RootStore from "../../core/stores/RootStore";
import { storeContext } from "../../core/stores/Context";
import { Step } from "../models/Game";
import { SwitchTransition, CSSTransition } from "react-transition-group";
import { useObserver } from "mobx-react-lite";
import styled from "styled-components";
import { GameContext } from "../stores/GameRootStore";
import { motion, AnimatePresence, useAnimation } from "framer-motion";
import { useWindowSize } from '../../core/utils/hooks';

const Word = motion.custom(styled.div`
  display: absolute;
  padding: 5px;
  background: gray;
  margin: 20px;
  color: white;
`);

const Container = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: lightgray;
`;

const WordsContainer = motion.custom(styled.div`
  display: flex;
  display: relative;
  max-width: 800px;
  max-height: 800px;
  width: 50%;
  height: 50%;
  overflow: hidden;
  flex-wrap: wrap;
  align-items: flex-start;
`);

interface Props {
  words: string[];
  onSelect: (word: string, rect: ClientRect) => void;
  getVisibleWord: (words: string[]) => void;
}

const WordsCloud: React.FC<Props> = (props: Props) => {
  const variants = {
    open: (i: number) => ({
      opacity: 1,
      y: 0,
      transition: {
        delay: i * 0.05
      }
    }),
    selected: {
      opacity: 1,
      y: 0,
      background: "orange",
      scale: [1, 2, 2, 1.2, 1.2],
    },
    closed: { opacity: 0, y: "-50px" }
  };


  const [ cutted, setCutted ] = useState(false);
  const [ divide, setDivide ] = useState<number | undefined>(undefined);
  const [ animated, setAnimated ] = useState(false);
  const { words, onSelect } = props;
  const [selectedWords, setSelectedWords] = useState<number[]>([]);
  const wordsRef = useRef<Element[]>([]);
  const lastDivide = (!cutted ? words.length : divide);

  useEffect(() => {
    if (cutted) {
      props.getVisibleWord(words.slice(0,divide));
      return;
    }
    const parentBounds = wordsRef.current[0].parentElement!.getBoundingClientRect();
    let parentTop = parentBounds.top;
    const parentHeight = parentBounds.height;
    let pageTop = parentTop;
    if (!animated) {
      pageTop -= 90;
    }
    for (let i = 0; i < wordsRef.current.length; i += 1) {
      const childNode = wordsRef.current[i]!;
      const childBounds = childNode.getBoundingClientRect()!;
      const offset = childBounds.bottom - pageTop;
      if (offset >= parentHeight) {
        setDivide(i);
        setCutted(true);
        return;
      }
    }
    setDivide(wordsRef.current.length);
    setCutted(true);
  },[cutted]);

  useWindowSize(() => {
    setCutted(false);
  });

  useEffect(() => {
    setAnimated(true);
  }, []);

  return (
    <div style={{ position: "relative", height: "100%", opacity: cutted ? 1:0 }}>
      <Container>
        <WordsContainer>
          {words.slice(0,lastDivide).map((word, i) => (
            <Word
              key={i}
              ref={(node) => {wordsRef.current[i] = node!}}
              onClick={e => {
                onSelect(word, (e.target as HTMLElement).getBoundingClientRect());
                setSelectedWords(selectedWords.concat(i));
              }}
              custom={i}

              initial={!animated ? "closed" : "open" }
              animate={selectedWords.findIndex(x => x === i) === -1 ? "open": "selected"}
              variants={variants}
            >
              {word}
            </Word>
          ))}
        </WordsContainer>
      </Container>
    </div>
  );
};

export default WordsCloud;
