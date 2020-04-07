import React, { useState, useContext } from "react";
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
  IonList,
  IonItemDivider,
  IonItem,
  IonInput,
  IonGrid,
  IonRow,
  IonCol,
  IonCard,
  IonCardHeader,
  IonCardSubtitle,
  IonCardTitle,
  IonCardContent,
  IonButton
} from "@ionic/react";
import { text } from "ionicons/icons";
import { storeContext } from "../stores/Context";
import { AlertContainer } from "../components/AlertContainer";

const LoginApp = () => {
  const { userStore, alertStore } = useContext(storeContext);
  const [word, setWord] = useState("");
  const [word2, setWord2] = useState("");
  const [number_, setNumber_] = useState("");
  const login = () => {
    userStore.login(word, word2, number_).catch(e => {
      alertStore.add(e.message, 500);
    });
  };
  return (
    <IonApp>
      <IonPage>
        <IonHeader>
          <IonToolbar>
            <IonTitle>Gorani Reader</IonTitle>
          </IonToolbar>
        </IonHeader>
        <IonContent>
          <IonHeader collapse="condense">
            <IonToolbar>
              <IonTitle size="large">Tab 1</IonTitle>
            </IonToolbar>
          </IonHeader>
          <IonGrid>
            <IonRow>
              <IonCol offsetMd="3" sizeMd="6">
                <IonCard>
                  <IonCardHeader>
                    <IonCardTitle>Login</IonCardTitle>
                  </IonCardHeader>
                  <IonCardContent>
                    <IonList>
                      <IonItem>
                        <IonInput
                          value={word}
                          onIonChange={e => {
                            setWord(e.detail.value!);
                          }}
                          placeholder="First Word"
                        ></IonInput>
                      </IonItem>
                      <IonItem>
                        <IonInput
                          value={word2}
                          onIonChange={e => {
                            setWord2(e.detail.value!);
                          }}
                          placeholder="Second Word"
                        ></IonInput>
                      </IonItem>
                      <IonItem>
                        <IonInput
                          value={number_}
                          onIonChange={e => {
                            setNumber_(e.detail.value!);
                          }}
                          placeholder="Number"
                        ></IonInput>
                      </IonItem>
                    </IonList>
                    <IonButton onClick={login}>Login</IonButton>
                  </IonCardContent>
                </IonCard>
              </IonCol>
            </IonRow>
          </IonGrid>
          <AlertContainer />
        </IonContent>
      </IonPage>
    </IonApp>
  );
};

export default LoginApp;
