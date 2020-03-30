import React from "react";
import { IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent } from "@ionic/react";
import styled from "styled-components";

const Layout: React.FC = (props) => {
  return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Gorani Reader</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent>
        {props.children}
      </IonContent>
    </IonPage>
  );
};

export default Layout;
