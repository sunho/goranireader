import React, { useEffect, useContext } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';
import WordsCloud from '../WordsCloud';
import { StepStore } from '../../stores/StepStore';

const Initial: React.FC<{store?: StepStore}> = props => {
  const { gameStore } = useContext(GameContext)!;
  const { store } = props;
  const lastWords = gameStore.progress.review.lastWords;
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "너가 저번에 읽었던 분량에서 나온 단어들이다."
      },
      {
        msg: "이 중 모르는게 있으면 죄다 눌러라"
      },
      {
        msg: "빨리 안해?"
      }
    ])
  }, []);
  return (
    <WordsCloud words={lastWords.map(x => x.word)} onSelect={(word, rect) => {
      gameStore.clickedRectangle = rect;
      gameStore.currentLastWord = lastWords.find(x => x.word === word) || null;
    }}/>
  );
};

const LWReviewStepComponent = {
  substeps: [
    Initial
  ]
}

export default LWReviewStepComponent;
