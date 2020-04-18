import React, { useContext, useRef } from "react";
import {
  IonButton
} from "@ionic/react";
import { storeContext } from "../../core/stores/Context";
import GameRootStore, { GameContext } from "../stores/GameRootStore";
import StepperContainer from "../components/StepperContainer";
import { register } from "../components/steps";
import { useObserver } from "mobx-react";
import DialogContainer from "../components/DialogContainer";
import LastWordDetailContainer from "../components/LastWordDetailContainer";
import styled from "styled-components";
import { Redirect } from "react-router";

register();

const Container = styled.div`
  display: grid;
  height: 100%;
  width: 100vw;
  grid-template-rows: 1fr auto auto
`;

const NextContainer = styled.div`
  display: grid;
  grid-auto-flow: column;
  justify-content: end;
  padding-right: 10px;
  padding-top: 10px;
  padding-bottom: 10px;
  width: 100%;
`;

const GamePage: React.FC = props => {
  const rootStore = useContext(storeContext)!;
  const { userStore } = rootStore;
  const review = userStore.user.review;

  const gameRootStore = useRef(
    review ? new GameRootStore(rootStore, review) : undefined
  );
  return useObserver(() => {
    const { gameStore } = gameRootStore.current;
    return (
      <>
        {(!gameStore.ended && userStore.hasReview ) ? (
          <GameContext.Provider value={gameRootStore.current}>
            <LastWordDetailContainer />
            <Container>
              <StepperContainer />
              <DialogContainer />
              <NextContainer>
                <IonButton
                  disabled={!gameStore.canGiveup}
                  onClick={() => {
                    gameStore.giveup();
                  }}
                >
                  Give up
                </IonButton>
                <IonButton
                  disabled={!gameStore.canNext}
                  onClick={() => {
                    gameStore.next();
                  }}
                >
                  Next
                </IonButton>
                <IonButton
                  disabled={!gameStore.canComplete}
                  onClick={() => {
                    gameStore.complete();
                  }}
                >
                  Complete
                </IonButton>
              </NextContainer>
            </Container>
          </GameContext.Provider>
        ) : (
          <Redirect to="/" />
        )}
      </>
    );
  });
};
export default GamePage;
