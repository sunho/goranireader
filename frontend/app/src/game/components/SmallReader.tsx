import React, { useContext, useEffect, useMemo } from 'react';
import { Item } from '../../core/models';
import ReaderRootStore, { ReaderContext } from '../../reader/stores/ReaderRootStore';
import { storeContext } from '../../core/stores/Context';
import GameReaderStore from '../stores/GameReaderStore';
import Reader from '../../reader/components/Reader';
import { GameContext } from '../stores/GameRootStore';

interface Props {
  sentences: Item[];
  targetWords: string[];
}


const SmallReader: React.FC<Props> = props => {
  const rootStore = useContext(storeContext)!;
  const { gameStore } = useContext(GameContext)!;
  const store = useMemo(() => new ReaderRootStore(rootStore, new GameReaderStore(props.sentences, gameStore, props.targetWords)), []);
  useEffect(() => {
    return () => {
      store.readerStore.destroy()
    }
  }, []);
  return (
    <ReaderContext.Provider value={store}>
      <Reader hightlightWord={props.targetWords}/>
    </ReaderContext.Provider>
  );
}

export default SmallReader;
