import React, { useContext, useState, useRef } from 'react';
import RootStore from '../../core/stores/RootStore';
import { storeContext } from '../../core/stores/Context';
import { Step } from '../models/Game';
import { SwitchTransition, CSSTransition } from 'react-transition-group';
import { useObserver } from 'mobx-react';
import styled from 'styled-components';
import { GameContext } from '../stores/GameRootStore';
import { motion, AnimatePresence } from "framer-motion";

const ContainerContainer = styled.div`
  position: relative;
  flex: 0 0 auto;
  height: 100px;
  width: 100%;
`;

const Container = styled.div`
  height: 100%;
  vertical-align: middle;
  text-align: center;
  background: gray;
`;

const DialogContainer = () => {
  const { gameStore } = useContext(GameContext);

  return useObserver(() => {
    const { msgs, msgIndex } = gameStore;
    return (
      <ContainerContainer>
        <AnimatePresence>
          {msgs &&
          <motion.div
            key={msgIndex}
            initial={{ opacity: 0, top: "20px" }}
            transition={{duration: 0.3}}
            animate={{ opacity: 1, top: 0}}
            style={{position: 'absolute', width: "100%", height: '100%'}}
            exit={{ opacity: 0, top: "-20px" }}
          >
            <Container onClick={() =>{
              gameStore.nextMsg();
            }}>
              {msgs[msgIndex].msg}
            </Container>
          </motion.div>
          }
        </AnimatePresence>
      </ContainerContainer>
    )});

};

export default DialogContainer;
