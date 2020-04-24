import React, { useContext, useState, useRef, useEffect, useMemo } from "react";
import styled, { css } from "styled-components";
import { GameContext } from "../stores/GameRootStore";
import { motion, useAnimation } from "framer-motion";
import { useObserver } from "mobx-react";
import { useOutsideClickObserver } from "../../core/utils/hooks";
import { storeContext } from "../../core/stores/Context";
import DictResultList from "../../reader/components/DictResultList";
import SmallReader from "./SmallReader";

const Word = motion.custom(styled.div`
  display: absolute;
  padding: 5px;
  background: gray;
  margin: 20px;
  color: white;
`);

const Container = motion.custom(styled.div`
  position: absolute;
  background: white;
`);

const ContainerContainer = styled.div<{ closed: boolean; }>`
  position: fixed;
  height: 100vh;
  width: 100vw;
  z-index: 53;
  pointer-events: auto;
  ${props => (
    props.closed && css`
      pointer-events: none;
    `
  )}
`;

const Content = motion.custom(styled.div`
  height: 100%;
`);

const LastWordDetailContainer = () => {
  const { gameStore } = useContext(GameContext);
  const { dictService } = useContext(storeContext);
  const controls = useAnimation();
  const contentControls = useAnimation();
  const [_, rerender] = useState(false);
  const conRef = useRef<HTMLElement | null | undefined>(undefined);
  const { currentLastWord, clickedRectangle } = gameStore;
  const [ currentWord, setCurrentWord ] = useState({word: '', sentences: []});
  const [ dictResults, setDictResults ] = useState([]);


  useOutsideClickObserver(conRef, () => {
    if (gameStore.currentLastWord) {
      gameStore.onCancelLastWordDetail.trigger();
      gameStore.currentLastWord = null;
    }
  });

  useEffect(() => {
    const variants = {
      open: {
        opacity: 1,
        width: "80%",
        height: "500px",
        left: "10%",
        top: "10%",
        transition: {
          type: 'tween',
          ease: 'circOut',
          duration: 0.3
        }
      },
      closed: {
        opacity: 0,
        width: clickedRectangle?.width || 0,
        height: clickedRectangle?.height || 0,
        left: clickedRectangle?.left || 0,
        top: clickedRectangle?.top || 0,
        transition: {
          type: 'tween',
          ease: 'circOut',
          duration: 0.3
        }
      },
      none: {
        width: 0,
        height: 0,
        opacity: 0
      }
    };

    if (currentLastWord) {
      (async () => {
        await controls.start(variants.closed, {duration: 0.001});
        await controls.start(variants.open);
        setDictResults(dictService.find(currentLastWord.word));
        setCurrentWord({ word: currentLastWord.word, sentences: currentLastWord.items });
      })();
    } else {
      (async () => {
        controls.stop();
        setCurrentWord({word: '', sentences: []});
        setDictResults([]);
        controls.start(variants.closed, {type: 'tween', ease: 'circOut', duration: 0.4});
      })();
    }
  }, [currentLastWord]);

  return useObserver(() => {
    const { currentLastWord } = gameStore;

    return (
      <ContainerContainer closed={currentLastWord == null}>
        <Container
          ref={conRef}
          animate={controls}
        >
          <Content animate={contentControls}>
            <div style={{height: "50%"}}>
              {currentWord.sentences.length !== 0 && <SmallReader targetWords={[currentWord.word]} key={currentLastWord ? '1':'0'} sentences={currentWord.sentences}/>}
            </div>
            <div style={{height: "50%"}}>
              {dictResults.length !== 0 && <DictResultList key={currentLastWord ? '1':'0'} res={dictResults}/>}
            </div>
          </Content>
        </Container>
        </ContainerContainer>
    );
  });
};

export default LastWordDetailContainer;
