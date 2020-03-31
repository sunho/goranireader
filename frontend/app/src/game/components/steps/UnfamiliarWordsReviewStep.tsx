import React, { useEffect, useContext } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';
import WordsCloud from '../WordsCloud';
import { UnfamiliarWordsReview } from '../../models/Game';

const PickWords: React.FC<{store: any}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const { store } = props;
  const lastWords = gameStore.progress.review.lastWords;
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "이번에 보이는 단어들은 옛날에 너가 봤던 단어들이야"
      },
      {
        msg: "모르는 단어가 있으면 죄다 누르고 아래 Next를 눌러"
      },
    ]);
    gameStore.setNext(() => {
      console.log("finalize");
      gameStore.gotoSubstep(1);
    });
  }, []);
  return (
    <WordsCloud words={lastWords.map(x => x.word)} onSelect={(word, rect) => {

    }}/>
  );
};

const ReadText: React.FC<{store: any}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const { store } = props;
  const lastWords = gameStore.progress.review.lastWords;
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: ""
      },
    ]);
    gameStore.setNext(() => {
      console.log("finalize");
      gameStore.gotoSubstep(0);
    });
  }, []);
  return (
    <SmallReader/>
  );
};

class Store {
  constructor(step: UnfamiliarWordsReviewStep)
}

const UnfamiliarWordsReviewStep = {
  storeGenerator: () => ({}),
  substeps: [
    PickWords,
    ReadText
  ]
}

export default UnfamiliarWordsReviewStep;
