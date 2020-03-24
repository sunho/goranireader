import React from "react";
import { IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent } from "@ionic/react";

interface Props {
  title: string;
}

const Layout: React.FC<Props> = (props) => {
  return (
    <IonPage>
      <IonContent>
        {props.children}
      </IonContent>
    </IonPage>
  );
};

export default Layout;
