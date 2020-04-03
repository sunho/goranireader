import React, { useContext, useState, useRef, useEffect } from "react";
import RootStore from "../../core/stores/RootStore";
import { storeContext } from "../../core/stores/Context";
import { Step, Review } from "../models/Game";
import { SwitchTransition, CSSTransition } from "react-transition-group";
import { useObserver } from "mobx-react";
import styled from "styled-components";
import { GameContext } from "../stores/GameRootStore";
import { motion, AnimatePresence } from "framer-motion";
import { isObservable, observe } from "mobx";
import GameStore from "../stores/GameStore";
import {
  StepStoreGenerator,
  SubStep,
  wrapStore,
  StepStore
} from "../stores/StepStore";

interface Props {
  storeGenerator?: StepStoreGenerator;
  substeps: SubStep[];
  step: Step;
}

const Container = styled.div`
  height: 100%;
  width: 100%;
`;

const Stepper = (props: Props) => {
  const rootStore = useContext(storeContext)!;
  const { gameStore } = useContext(GameContext)!;
  const { storeGenerator, substeps, step } = props;
  const [store, _] = useState<StepStore | undefined>( storeGenerator
    && wrapStore(
        gameStore,
        gameStore.step,
        storeGenerator(step, gameStore.progress.review, rootStore)
      ));
  return useObserver(() => {
    const CurrentStep = substeps[gameStore.substep];
    return (
      <div style={{ position: "relative", width: "100%", height: "100%" }}>
        <AnimatePresence>
          <motion.div
            key={gameStore.substep + '-' + gameStore.substepI}
            initial={{ opacity: 0, left: "10%", rotate: 10 }}
            transition={{ duration: 0.3 }}
            animate={{ opacity: 1, left: 0, rotate: 0 }}
            style={{ position: "absolute", height: "100%", width: "100%" }}
            exit={{ opacity: 0, left: "-10%", rotate: -10 }}
          >
            <Container>
              <CurrentStep store={store} />
            </Container>
          </motion.div>
        </AnimatePresence>
      </div>
    );
  });
};

export default Stepper;
