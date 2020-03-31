import React, { useContext, useEffect, useState } from 'react';
import { Sentence } from '../../core/models';
import ReaderRootStore, { ReaderContext } from '../../reader/stores/ReaderRootStore';
import { storeContext } from '../../core/stores/Context';
import GameReaderStore from '../stores/GameReaderStore';
import Reader from '../../reader/components/Reader';
import Dict from '../../reader/components/Dict';

interface Props {
  sentences: Sentence[];
}


const SmallReader: React.FC<Props> = props => {
  const rootStore = useContext(storeContext)!;
  const store = new ReaderRootStore(rootStore, new GameReaderStore(props.sentences));
  return (
    <ReaderContext.Provider value={store}>
      <Reader/>
    </ReaderContext.Provider>
  );
}

export default SmallReader;
