import React from 'react';
import { IonApp, IonTabs, IonRouterOutlet, IonTabBar, IonTabButton, IonIcon, IonLabel, IonPage, IonHeader, IonToolbar, IonTitle, IonContent } from "@ionic/react";
import { IonReactRouter, IonReactHashRouter } from "@ionic/react-router";
import { Route, Redirect } from "react-router";
import { triangle, ellipse, square } from "ionicons/icons";
import ExploreContainer from '../components/ExploreContainer';
import BooksPage from './BooksPage';
import { isPlatform } from '@ionic/react';
import ReaderPage from './ReaderPage';

const HomeApp = () => {
  const items = (
    <IonRouterOutlet>
      <Route path="/reader/:id" component={ReaderPage} />
      <Route exact path="/" component={BooksPage} />
    </IonRouterOutlet>
  );
  return (
   <IonApp>
    {isPlatform('electron') ?
    (
      <IonReactHashRouter>
        {items}
      </IonReactHashRouter>
    ):
    (
      <IonReactRouter>
        {items}
      </IonReactRouter>
    )}
  </IonApp>
  );
};

export default HomeApp;
