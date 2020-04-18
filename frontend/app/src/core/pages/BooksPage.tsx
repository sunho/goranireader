import React, { useContext } from "react";
import {
  IonGrid,
  IonRow,
  IonCol,
  IonText,
  IonButton
} from "@ionic/react";
import { storeContext } from "../stores/Context";
import { useObserver } from "mobx-react";
import { Book } from "../models";
import BookItem from "../components/BookItem";
import Layout from "../components/Layout";
import styled from "styled-components";

const Text = styled(IonText)`
  margin: 0 10px;
`;

const BooksPage = ({ history }) => {
  const { bookStore, userStore } = useContext(storeContext)!;
  const click = (book: Book) => {
    if (!bookStore.downloaded.has(book.id)) {
      bookStore.download(book).then(() => {
        bookStore.refresh().catch(() => {});
      });
    } else {
      history.push("/reader/" + book.id);
    }
  };

  let gotoGame: any = undefined;
  if (userStore.hasReview) {
    gotoGame = (
      <>
        <IonRow>
          <Text>
            <h3>Review Game Available</h3>
          </Text>
        </IonRow>
        <IonRow>
          <IonButton href="/game">GO</IonButton>
        </IonRow>
      </>
    );
  }
  return useObserver(() => (
    <Layout>
      <IonGrid>
        {gotoGame}
        <IonRow>
          <Text>
            <h3>Books</h3>
          </Text>
        </IonRow>
        <IonRow>
          {bookStore.books.map(x => (
            <IonCol size="12" sizeMd="6" sizeLg="4" sizeXl="3">
              <BookItem
                key={x.id}
                title={x.title}
                cover={x.cover}
                coverType={x.coverType}
                onClick={() => {
                  click(x);
                }}
              />
            </IonCol>
          ))}
        </IonRow>
        <IonRow>
          <Text>
            <h3>Coming</h3>
          </Text>
        </IonRow>
      </IonGrid>
    </Layout>
  ));
};

export default BooksPage;
