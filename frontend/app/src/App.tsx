import React, { useEffect, useState } from 'react';

/* Core CSS required for Ionic components to work properly */
import '@ionic/react/css/core.css';

/* Basic CSS for apps built with Ionic */
import '@ionic/react/css/normalize.css';
import '@ionic/react/css/structure.css';
import '@ionic/react/css/typography.css';

/* Optional CSS utils that can be commented out */
/* Theme variables */
import './theme/variables.css';
import { storeContext } from './core/stores/Context';
import { useObserver } from 'mobx-react';
import HomeApp from './core/pages/HomeApp';
import LoginApp from './core/pages/LoginApp';
import { IonApp, IonContent, IonLoading, IonSpinner } from '@ionic/react';

const App: React.FC = () => {
  const [inited, setInited] = useState(false);
  const { saveStore, firebaseService, userStore } = React.useContext(storeContext);
  useEffect(() => {
    (async () => {
      await firebaseService.init();
      await saveStore.init();
      try {
        await userStore.loadUser();
      } catch { }
      setInited(true);
    })();
  },[]);
  const Loading = () => (
    <IonApp>
      <IonContent>
        <IonSpinner name="crescent"/>
      </IonContent>
    </IonApp>
  );
  return useObserver(() => (inited ? (userStore.user ? <HomeApp/> : <LoginApp/>) : <Loading/>));
};

export default App;

