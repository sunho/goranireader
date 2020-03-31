import React, { useContext, useState, useRef, useEffect } from "react";
import RootStore from "../../core/stores/RootStore";
import { storeContext } from "../../core/stores/Context";
import { Step } from "../models/Game";
import { SwitchTransition, CSSTransition } from "react-transition-group";
import { useObserver } from "mobx-react-lite";
import styled from "styled-components";
import { GameContext } from "../stores/GameRootStore";
import { motion, AnimatePresence, useAnimation } from "framer-motion";

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
`;

const WordsContainer = motion.custom(styled.div`
  display: flex;
  display: relative;
  max-width: 200px;
  flex-wrap: wrap;
`);

interface Props {
  words: string[];
  onSelect: (word: string, rect: ClientRect) => void;
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

  const { words, onSelect } = props;
  const [selectedWords, setSelectedWords] = useState<number[]>([]);

  return (
    <div style={{ position: "relative", height: "100%" }}>
      <Container>
        <WordsContainer>
          {words.map((word, i) => (
            <Word
              key={i}
              onClick={e => {
                onSelect(word, (e.target as HTMLElement).getBoundingClientRect());
                setSelectedWords(selectedWords.concat(i));
              }}
              custom={i}
              initial="closed"
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
