import React, { useContext } from 'react';
import { IonApp, IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonVirtualScroll, IonList, IonCard, IonCardTitle, IonItem, IonGrid, IonRow, IonCol, IonText } from "@ionic/react";
import { storeContext } from '../stores/Context';
import { useObserver } from 'mobx-react-lite';
import { Book } from '../models';
import BookItem from '../components/BookItem';
import Layout from '../components/Layout';
import styled from 'styled-components';

const Text = styled(IonText)`
  margin: 0 10px;
`;

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
    <Layout>
      <IonGrid>
        <IonRow>
          <Text>
            <h3>
              Books
            </h3>
          </Text>
        </IonRow>
        <IonRow>

        {
          bookStore.books.map(x => (
            <IonCol size="12" sizeMd="6" sizeLg="4" sizeXl="3">
              <BookItem key={x.id} title={x.title} cover={x.cover} coverType={x.coverType} onClick={() => {click(x)}}/>
            </IonCol>
          ))
        }
        </IonRow>
        <IonRow>
          <Text>
            <h3>
              Coming
            </h3>
          </Text>
        </IonRow>
      </IonGrid>
    </Layout>
  ));
};

export default BooksPage;
