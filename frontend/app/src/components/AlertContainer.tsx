import React, { useContext } from 'react';
import { storeContext } from '../stores/Context';
import { IonToast } from '@ionic/react';
import { useObserver } from 'mobx-react-lite';

export const AlertContainer = () => {
  const { alertStore } = useContext(storeContext);
  return useObserver(() => (
    <>
      {alertStore.msgs.map(x => (
        <IonToast
          isOpen={true}
          key={x.id}
          message={x.msg}
          duration={x.duration}
          onDidDismiss={() => { alertStore.remove(x.id); }}
        />
      ))}

    </>
  ));
}
