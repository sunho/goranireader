import React, { useContext, useRef, useEffect, useState } from "react";
import {
  IonApp,
  IonTabs,
  IonRouterOutlet,
  IonTabBar,
  IonTabButton,
  IonIcon,
  IonLabel,
  IonPage,
  IonHeader,
  IonToolbar,
  IonTitle,
  IonContent,
  IonVirtualScroll,
  IonList,
  IonCard,
  IonCardTitle,
  IonItem,
  useIonViewWillEnter,
  useIonViewDidEnter,
  IonMenu,
  IonMenuButton,
  IonBackButton,
  IonButtons,
  IonButton,
  IonMenuToggle,
  IonSlide,
  IonRange,
  IonToggle
} from "@ionic/react";
import { storeContext } from "../../core/stores/Context";
import { useObserver } from "mobx-react-lite";
import { Book } from "../../core/models";
import Reader from "../components/Reader";
import { RouteComponentProps } from "react-router";
import ReaderStore from "../stores/ReaderUIStore";
import { book } from "ionicons/icons";
import ReaderRootStore, { ReaderContext } from "../stores/ReaderRootStore";
import styled from "styled-components";
import "./ReaderPage.css";
import BookReaderStore from "../stores/BookReaderStore";

interface BooksParameters
  extends RouteComponentProps<{
    id: string;
  }> {}

const Main = styled.div`
  display: block;
  padding: 10px 5px;
  height: calc(100% - 20px);
  width: calc(100vw - 10px);
`;

const ReaderContainer = styled.div`
  overflow: hidden;
  width: calc(100vw - 10px);
  height: 100%;
`;

const ReaderPage: React.FC<BooksParameters> = ({ match, history }) => {
  const rootStore = useContext(storeContext);
  const { bookStore } = rootStore;
  const [readerRootStore, setReaderRootState] = useState<
    ReaderRootStore | undefined
  >(undefined);
  const { id } = match.params;
  useEffect(() => {
    (async () => {
      const book = await bookStore.open(id);
      const store = new ReaderRootStore(rootStore, new BookReaderStore(book));
      (window as any).readerRootStore = store;
      setReaderRootState(store);
    })().catch(e => console.error(e));
  }, []);

  if (readerRootStore) {
    return (
      <ReaderContext.Provider value={readerRootStore}>
        <ReaderPageContent />
      </ReaderContext.Provider>
    );
  }
  return <></>;
};

const ReaderPageContent: React.FC = () => {
  const readerRootStore = useContext(ReaderContext);
  const { readerUIStore } = readerRootStore;
  const readerStore = readerRootStore.readerStore as BookReaderStore;
  const [checked, setChecked] = useState(false);
  return useObserver(() => (
    <>
      <IonMenu
        swipeGesture={false}
        side="start"
        contentId="content1"
        menuId="first"
      >
        <IonHeader>
          <IonToolbar color="primary">
            <IonTitle>Go to Chapter</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonContent className="no-scroll">
          <IonList>
            {readerStore.book.chapters.map(x => (
              <IonItem
                disabled={x.id === readerStore.location.chapterId}
                key={x.id}
                button={x.id !== readerStore.location.chapterId}
                onClick={() => {
                  readerUIStore.clearDivision();
                  readerStore.location.chapterId = x.id;
                }}
              >
                {x.title === "" ? "gorani" : x.title}
              </IonItem>
            ))}
          </IonList>
        </IonContent>
      </IonMenu>
      <IonMenu
        swipeGesture={false}
        side="end"
        contentId="content2"
        menuId="tools"
      >
        <IonHeader>
          <IonToolbar color="primary">
            <IonTitle>Tools</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonContent>
          <IonList>
            <IonItem> Font size</IonItem>
            <IonItem>
              <IonRange
                min={10}
                max={40}
                pin={true}
                value={readerUIStore.fontSize}
                onIonChange={e =>
                  (readerUIStore.fontSize = e.detail.value as number)
                }
              />
            </IonItem>
            '<IonItem> Theme </IonItem>
            <IonItem>
              {" "}
              <IonToggle
                checked={checked}
                onIonChange={ev => {
                  setChecked(ev.detail.checked);
                  document.body.classList.toggle("dark", ev.detail.checked);
                }}
              >
                Toggle
              </IonToggle>
            </IonItem>
            '
          </IonList>
        </IonContent>
      </IonMenu>
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>{readerStore.book.meta.title}</IonTitle>
            <IonButtons slot="start">
              <IonBackButton defaultHref="/" />
            </IonButtons>
            <IonButtons slot="end">
              <IonMenuToggle autoHide={false} menu="first">
                <IonButton>go to</IonButton>
              </IonMenuToggle>
              <IonMenuToggle autoHide={false} menu="tools">
                <IonButton>tools</IonButton>
              </IonMenuToggle>
            </IonButtons>
          </IonToolbar>
        </IonHeader>
        <IonContent>
          <Main>
            <ReaderContainer>
              <Reader key={readerStore.currentChapter.id} />
            </ReaderContainer>
          </Main>
        </IonContent>
      </IonPage>
      <IonRouterOutlet id="content1"></IonRouterOutlet>
      <IonRouterOutlet id="content2"></IonRouterOutlet>
    </>
  ));
};

export default ReaderPage;
