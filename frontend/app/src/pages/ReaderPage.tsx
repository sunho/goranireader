import React, { useContext, useRef, useEffect, useState } from 'react';
import { IonApp, IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonVirtualScroll, IonList, IonCard, IonCardTitle, IonItem, useIonViewWillEnter, useIonViewDidEnter } from "@ionic/react";
import ExploreContainer from '../components/ExploreContainer';
import { storeContext } from '../stores/Context';
import { useObserver } from 'mobx-react-lite';
import { Book } from '../models';
import Reader from '../components/reader/Reader';
import { RouteComponentProps } from 'react-router';
import ReaderStore from '../stores/ReaderStore';
import { book } from 'ionicons/icons';

interface BooksParameters extends RouteComponentProps<{
  id: string;
}> {}

const ReaderPage: React.FC<BooksParameters> = ({match, history}) => {
  const rootStore = useContext(storeContext);
  const { bookStore } = rootStore;
  const [readerStore, setReaderState] = useState<ReaderStore | undefined>(undefined);
  const { id } = match.params;
  useEffect(() => {
    (async () => {
      const file = bookStore.downloaded.get(id);
      if (!file) {
        history.push('/');
        return;
      };
      const book = await bookStore.open(file);
      setReaderState(new ReaderStore(rootStore, book));
    })().catch(e => console.error(e));
  },[]);

  return useObserver(() => (
    <>
    {(readerStore)&& (
      <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Books</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent>
        <Reader key={readerStore.currentChapter.id} readerStore={readerStore} sentences={readerStore.currentChapter.items}/>
      </IonContent>
    </IonPage>
    )}
    </>
  ));
};

export default ReaderPage;
