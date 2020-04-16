import React, { useEffect, useContext } from 'react';
import { GameContext } from '../../stores/GameRootStore';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend,
} from 'recharts';
import { StepStore } from '../../stores/StepStore';
import styled from 'styled-components';

const Container = styled.div`
  display: grid;
  justify-content: center;
  align-items: center;
  height: 100%;
`;

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
        msg: "읽은 단어수 통계",
        goToSubstep: 1
      },
      {
        msg: "wpm 통계",
        goToSubstep: 2
      },
      {
        msg: "소요 시간 (hour) 통계",
        goToSubstep: 3
      },
    ], () => {
      gameStore.nextStep();
    })
  }, []);
  return (
    <div>Stat Review {gameStore.substep} </div>
  );
};

const WordStats: React.SFC = () => {
  const { gameStore } = useContext(GameContext)!;
  const { progress } = gameStore;
  return (
    <Container>
      <LineChart width={500} height={300} data={progress.review.stats!.lastReadWords}>
        <XAxis dataKey="time"/>
        <YAxis/>
        <CartesianGrid stroke="#eee" strokeDasharray="5 5"/>
        <Line type="monotone" dataKey="y" stroke="#82ca9d" />
      </LineChart>
    </Container>
  );
};

const WPMStats: React.SFC = () => {
  const { gameStore } = useContext(GameContext)!;
  const { progress } = gameStore;
  return (
    <Container>
      <LineChart width={500} height={300} data={progress.review.stats!.wpm}>
        <XAxis dataKey="time"/>
        <YAxis/>
        <CartesianGrid stroke="#eee" strokeDasharray="5 5"/>
        <Line type="monotone" dataKey="y" stroke="#82ca9d" />
      </LineChart>
    </Container>
  );
};

const HoursStats: React.SFC = () => {
  const { gameStore } = useContext(GameContext)!;
  const { progress } = gameStore;
  return (
    <Container>
      <LineChart width={500} height={300} data={progress.review.stats!.hours}>
        <XAxis dataKey="time"/>
        <YAxis/>
        <CartesianGrid stroke="#eee" strokeDasharray="5 5"/>
        <Line type="monotone" dataKey="y" stroke="#82ca9d" />
      </LineChart>
    </Container>
  );
};

const StatsReviewStep = {
  substeps: [
    Initial,
    WordStats,
    WPMStats,
    HoursStats
  ]
}

export default StatsReviewStep;
