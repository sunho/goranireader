import React, { useState, useRef, useEffect } from "react";
import styled from "styled-components";
import { motion } from "framer-motion";
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
  onDeselect: (word: string) => void;
  getVisibleWord: (words: string[]) => void;
}

const WordsCloud: React.FC<Props> = (props: Props) => {
  const variants = {
    open: (i: number) => ({
      opacity: 1,
      y: 0,
      background: "gray",
      scale: 1,
      transition: {
        delay: !animated ? i * 0.05 : 0
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


  const [ loaded, setLoaded ] = useState(false);
  const [ cutted, setCutted ] = useState(false);
  const [ divide, setDivide ] = useState<number | undefined>(undefined);
  const [ animated, setAnimated ] = useState(false);
  const { words, onSelect, onDeselect } = props;
  const [selectedWords, setSelectedWords] = useState<number[]>([]);
  const wordsRef = useRef<Element[]>([]);
  const lastDivide = (!cutted ? words.length : divide);

  useEffect(() => {
    if (!loaded) {
      return;
    }
    if (cutted) {
      props.getVisibleWord(words.slice(0,divide));
      setAnimated(true);
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
  },[loaded, cutted]);

  useEffect(() => {
    const parent = wordsRef.current[0].parentElement;
    if (parent!.getBoundingClientRect().height === 0) {
      window.requestAnimationFrame(() => {
        setLoaded(true);
      });
    } else {
      setLoaded(true);
    }
  },[]);

  useWindowSize(() => {
    setCutted(false);
  });

  return (
    <div style={{ position: "relative", height: "100%", opacity: cutted ? 1:0 }}>
      <Container>
        <WordsContainer>
          {words.slice(0,lastDivide).map((word, i) => (
            <Word
              key={i}
              ref={(node) => {wordsRef.current[i] = node!}}
              onClick={e => {
                if (selectedWords.includes(i)) {
                  onDeselect(word);
                  setSelectedWords(selectedWords.filter(x => (x !== i)));
                } else {
                  onSelect(word, (e.target as HTMLElement).getBoundingClientRect());
                  setSelectedWords(selectedWords.concat(i));
                }
              }}
              custom={i}

              initial={!animated ? "closed" : "open" }
              animate={selectedWords.includes(i) ? "selected":"open"}
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
