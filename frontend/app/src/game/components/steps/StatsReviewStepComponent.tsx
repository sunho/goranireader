import React, { useEffect, useContext } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';
import { StepStore } from '../../stores/StepStore';

const Initial: React.SFC = () => {
  const { gameStore } = useContext(GameContext)!;
  useEffect(() => {
    gameStore.pushDialog([
      {
        msg: "야 내가 고라니다"
      },
      {
        msg: "지금부터 난 널 갈굴거야"
      },
      {
        msg: "덤벼"
      },
      {
        msg: "하하"
      },
      {
        msg: "이번주 단어 통계다 이게",
        goToSubstep: 1
      },
    ])
  }, []);
  return (
    <div>Stat Review {gameStore.substep} </div>
  );
};

const WordStats: React.SFC = () => {
  const { gameStore } = useContext(GameContext)!;
  const { progress } = gameStore;
  return (
    <div>
      <LineChart width={500} height={300} data={progress.review.stats.lastReadWords}>
        <XAxis dataKey="time"/>
        <YAxis/>
        <CartesianGrid stroke="#eee" strokeDasharray="5 5"/>
        <Line type="monotone" dataKey="y" stroke="#82ca9d" />
      </LineChart>
    </div>
  );
};

const StatsReviewStep = {
  substeps: [
    Initial,
    WordStats,
  ]
}

export default StatsReviewStep;
