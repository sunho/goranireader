import React, { useContext, useRef } from 'react';
import { IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonToolbar, IonTitle, IonList, IonButton } from "@ionic/react"
import { storeContext } from '../../core/stores/Context';
import { Review } from '../models/Game';
import GameRootStore, { GameContext } from '../stores/GameRootStore';
import StepperContainer from '../components/StepperContainer';
import { register } from '../components/steps';
import { useObserver } from 'mobx-react';
import DialogContainer from '../components/DialogContainer';
import LastWordDetailContainer from '../components/LastWordDetailContainer';
import styled from 'styled-components';

register();

const Container = styled.div`
  display: flex;
  height: 100%;
  width: 100vw;
  flex-direction: column;
`;

const NextContainer = styled.div`
  flex: 0 0 30px;
  display: flex;
  justify-content: flex-end;
  padding-right: 10px;
  padding-top: 10px;
  padding-bottom: 10px;
  width: 100%;
`;

const GamePage: React.FC = (props) => {
  const rootStore = useContext(storeContext);
  const review: Review = {
    time: new Date().toISOString(),
    stats: {
      lastReadWords: [
        {time: "10-1", y: 123},
        {time: "10-2", y: 143},
      ],
      wpm: [],
      hours: [],
    },
    lastWords: [{
      word: 'hello',
      sentences: [{
        id: 'asdf',
        content: 'Hey hello hey hey hey.',
        kind: 'sentence',
        start: false
      }],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },{
      word: 'hello',
      sentences: [],
      sid: ''
    },],
    targetLastWords: 10,
    unfamiliarWords: [],
    targetUnfamiliarWords: 10,
    texts: [],
  };
  const gameRootStore = useRef(new GameRootStore(rootStore, review));
  return useObserver(() => {
    const { gameStore } = gameRootStore.current;
    return (
      <GameContext.Provider value={gameRootStore.current}>
        <LastWordDetailContainer/>
        <Container>
          <StepperContainer/>
          <DialogContainer/>
          <NextContainer>
            <IonButton disabled={!gameStore.canGiveup} onClick={() => {gameStore.giveup()}}>
              Give up
            </IonButton>
            <IonButton disabled={!gameStore.canNext} onClick={() => {gameStore.next()}}>
              Next
            </IonButton>
            <IonButton disabled={!gameStore.canComplete} onClick={() => {gameStore.complete()}}>
              Complete
            </IonButton>
          </NextContainer>
        </Container>
      </GameContext.Provider>
    );
  });
};
export default GamePage;
