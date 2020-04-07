import React, { useEffect, useContext, useRef, useMemo } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';
import WordsCloud from '../WordsCloud';
import LWReviewStore from '../../stores/LWReviewStore';
import { LWReviewStep } from '../../models/Game';
import { StepComponent } from '../../stores/StepStore';

const Initial: React.FC<{store?: LWReviewStore}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const store = props.store!;
  const selectedWords = useRef(new Set<string>([]));
  const visibleWords = useRef<string[]>([]);
  const words = useMemo(() => (store.sampleWords()), []);
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "너가 저번에 읽었던 분량에서 나온 단어들이다. \n 이 중 모르는게 있으면 죄다 눌러라"
      },
    ]);

    if (store.shouldComplete()) {
      gameStore.nextStep();
    }

    if (store.canComplete()) {
      gameStore.setComplete(() => {
        store.logComplete();
        gameStore.nextStep();
      });
    }

    if (store.canGiveup()) {
      gameStore.setGiveup(() => {
        store.logGiveup();
        gameStore.nextStep();
      });
    }

    gameStore.setNext(() => {
      const selectedWords_ = Array.from(selectedWords.current.values());
      if (store.finalize(visibleWords.current, selectedWords_,)) {
        gameStore.nextStep();
      } else {
        gameStore.gotoSubstep(0);
      }
    });
  }, []);

  return (
    <WordsCloud getVisibleWord={(words) => {visibleWords.current = words; console.log(words)}} words={words.map(x => x.word)} onSelect={(word, rect) => {
      gameStore.clickedRectangle = rect;
      gameStore.currentLastWord = words.find(x => x.word === word) || null;
      selectedWords.current.add(word);
    }}/>
  );
};

const LWReviewStepComponent: StepComponent = {
  storeGenerator: (step, review, rootStore) => (new LWReviewStore(step as LWReviewStep, review, rootStore)),
  substeps: [
    Initial
  ]
}

export default LWReviewStepComponent;
