import React, { useContext } from 'react';
import { IonApp, IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonVirtualScroll, IonList, IonCard, IonCardTitle, IonItem, IonGrid, IonRow, IonCol } from "@ionic/react";
import ExploreContainer from '../components/ExploreContainer';
import { storeContext } from '../stores/Context';
import { useObserver } from 'mobx-react-lite';
import { Book } from '../models';
import BookItem from '../components/BookItem';
import Layout from '../components/Layout';

const BooksPage = ({history}) => {
  const { bookStore } = useContext(storeContext);
  const click = (book: Book) => {
    if (!bookStore.downloaded.has(book.id)) {
      bookStore.download(book).then(() => {bookStore.refresh().catch(() => {})});
    } else {
      history.push('/reader/'+book.id);
    }
  };
  return useObserver(() => (
    <Layout title="Books">
      <IonGrid>
        <IonRow>
        {
          bookStore.books.map(x => (
            <IonCol size="12" sizeMd="6" sizeLg="4" sizeXl="3">
              <BookItem key={x.id} title={x.title} cover={x.cover} coverType={x.coverType} onClick={() => {click(x)}}/>
            </IonCol>
          ))
        }
        </IonRow>
      </IonGrid>
    </Layout>
  ));
};

export default BooksPage;
