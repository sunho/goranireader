import React, { useEffect, useState } from 'react';

/* Core CSS required for Ionic components to work properly */
import '@ionic/react/css/core.css';

/* Basic CSS for apps built with Ionic */
import '@ionic/react/css/normalize.css';
import '@ionic/react/css/structure.css';
import '@ionic/react/css/typography.css';

/* Optional CSS utils that can be commented out */
import '@ionic/react/css/padding.css';
import '@ionic/react/css/float-elements.css';
import '@ionic/react/css/text-alignment.css';
import '@ionic/react/css/text-transformation.css';
import '@ionic/react/css/flex-utils.css';
import '@ionic/react/css/display.css';

/* Theme variables */
import './theme/variables.css';
import { storeContext } from './stores/Context';
import { useObserver } from 'mobx-react-lite';
import HomeApp from './pages/HomeApp';
import LoginApp from './pages/LoginApp';
import { IonApp, IonContent, IonLoading, IonSpinner } from '@ionic/react';

const App: React.FC = () => {
  const [inited, setInited] = useState(false);
  const { firebaseService, userStore } = React.useContext(storeContext);
  useEffect(() => {
    (async () => {
      await firebaseService.init();
      try {
        await userStore.loadUser();
      } catch { }
      setInited(true);
    })();
  },[]);
  const Loading = () => (
    <IonApp>
      <IonContent>
        <IonSpinner style={{margin: 'auto'}}/>
      </IonContent>
    </IonApp>
  );
  return useObserver(() => (inited ? (userStore.user ? <HomeApp/> : <LoginApp/>) : <Loading/>));
};

export default App;

