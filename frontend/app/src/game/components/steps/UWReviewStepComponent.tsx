import React, { useEffect, useContext, useState, useCallback, useRef, useMemo } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import WordsCloud from '../WordsCloud';
import { UWReviewStep, Progress, UnfamiliarWord, Text, Review } from '../../models/Game';
import UWReviewStore from '../../stores/UWReviewStore';
import { StepComponent, StepStore } from '../../stores/StepStore';
import SmallReader from '../../components/SmallReader';

const PickWords: React.FC<{store?: UWReviewStore}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const store = props.store!;
  const words = useMemo(() => store.sampleWords(), []);
  const selectedWords = useRef(new Set<string>([]));
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "이번에 보이는 단어들은 옛날에 너가 봤던 단어들이야. \n 모르는 단어가 있으면 죄다 누르고 아래 Next를 눌러"
      },
    ]);

    if (store.shouldComplete()) {
      gameStore.gotoSubstep(2);
    }

    if (store.canComplete()) {
      gameStore.setComplete(() => { });
    }

    if (store.canGiveup()) {
      gameStore.setGiveup(() => { });
    }

    gameStore.setNext(() => {
      const selectedWords_ = Array.from(selectedWords.current.values());
      if (store.finalizePickWords(selectedWords_, words)) {
        gameStore.gotoSubstep(1);

      } else {
        if (store.shouldComplete()) {
          gameStore.gotoSubstep(2);
        } else {
          gameStore.gotoSubstep(0);
        }
      }
    });

  }, []);
  const addWord = useCallback((word) => {
    selectedWords.current.add(word);
  }, []);

  return (
    <WordsCloud getVisibleWord={() => {}} words={words} onSelect={(word, rect) => {
      addWord(word);
    }}/>
  );
};

const ReadText: React.FC<{store?: UWReviewStore}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const store = props.store!;
  const text = useMemo(() => store?.suggestedTexts[store!.textPos], []);
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: ""
      },
    ]);

    if (store.shouldComplete()) {
      gameStore.gotoSubstep(2);
    }

    if (store.canComplete()) {
      gameStore.setComplete(() => { });
    }

    if (store.canGiveup()) {
      gameStore.setGiveup(() => { });
    }

    gameStore.setNext(() => {
      if (store.textPos !== store.suggestedTexts.length - 1) {
        store.textPos ++;
        gameStore.gotoSubstep(1);
      } else if (store.finalizeReadText()) {
        gameStore.gotoSubstep(2);
      } else {
        gameStore.gotoSubstep(0);
      }
    });
  }, []);
  return (
    <SmallReader targetWords={[]} sentences={text!.content}/>
  );
};

const Complete: React.FC<{store?: UWReviewStore}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const store = props.store!;
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "끝"
      },
    ]);
  });
  return (
    <></>
  );
}

const UWReviewStepComponent: StepComponent = {
  storeGenerator: (step, review, rootStore) => (new UWReviewStore(step as UWReviewStep, review, rootStore)),
  substeps: [
    PickWords,
    ReadText,
    Complete
  ]
}

export default UWReviewStepComponent;
