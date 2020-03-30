import React, { useState } from 'react';
import { useLocalStore } from 'mobx-react-lite';
import RootStore, { createStore } from './RootStore';

export const storeContext = React.createContext<RootStore | null>(null);

export const StoreProvider: React.FC = ({ children }) => {
	const [store, _] = useState(createStore());
  return (
    <storeContext.Provider value={store}>
      {children}
    </storeContext.Provider>
  );
};

export default StoreProvider;
