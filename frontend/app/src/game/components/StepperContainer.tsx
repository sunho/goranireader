import React, { useContext } from 'react';
import Stepper from './Stepper';
import { StepKind } from '../models/Game';
import { GameContext } from '../stores/GameRootStore';
import { useObserver } from 'mobx-react';
import styled from 'styled-components';
import { StepComponent } from '../stores/StepStore';

const Container = styled.div`
  width: 100%;
`;

const StepperContainer: React.FC = () => {
  const gameRootStore = useContext(GameContext);
  const { gameStore } = gameRootStore!;

  return useObserver(() => {
    console.log(gameStore.step);
    const step = gameStore.progress.steps[gameStore.step];
    const component = stepComponents.get(step.kind)!;
    return (
      <Container>
        <Stepper key={gameStore.step} step={step} storeGenerator={component.storeGenerator} substeps={component.substeps}/>
      </Container>
    );
  });
};

const stepComponents = new Map<StepKind, StepComponent>();

export function registerStepComponent(stepKind: StepKind, component: StepComponent) {
  stepComponents.set(stepKind, component);
}

export default StepperContainer;
