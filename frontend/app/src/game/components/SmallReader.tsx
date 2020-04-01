import React, { useContext, useEffect, useState, useMemo } from 'react';
import { Sentence, Item } from '../../core/models';
import ReaderRootStore, { ReaderContext } from '../../reader/stores/ReaderRootStore';
import { storeContext } from '../../core/stores/Context';
import GameReaderStore from '../stores/GameReaderStore';
import Reader from '../../reader/components/Reader';
import Dict from '../../reader/components/Dict';
import { GameContext } from '../stores/GameRootStore';

interface Props {
  sentences: Item[];
}


const SmallReader: React.FC<Props> = props => {
  const rootStore = useContext(storeContext)!;
  const gameStore = useContext(GameContext)!;
  const store = useMemo(() => new ReaderRootStore(rootStore, new GameReaderStore(props.sentences)), []);
  return (
    <ReaderContext.Provider value={store}>
      <Reader/>
    </ReaderContext.Provider>
  );
}

export default SmallReader;
