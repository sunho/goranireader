import React from "react";
import {
  IonApp,
  IonRouterOutlet,
} from "@ionic/react";
import { IonReactRouter, IonReactHashRouter } from "@ionic/react-router";
import { Route, Redirect } from "react-router";
import { isPlatform } from "@ionic/react";
import ReaderPage from "../../reader/pages/ReaderPage";
import TabsPage from "./TabsPage";
import GamePage from "../../game/pages/GamePage";

const HomeApp = props => {
  const items = (
    <IonRouterOutlet>
      <Route path="/game" component={GamePage} />
      <Route path="/reader/:id" component={ReaderPage} />
      <Route path="/main" component={TabsPage} />
      <Route exact path="/" render={() => <Redirect to="/main" />} />
      <Route render={() => <Redirect to="/main" />} />
    </IonRouterOutlet>
  );
  return (
    <IonApp>
      {isPlatform("electron") ? (
        <IonReactHashRouter>{items}</IonReactHashRouter>
      ) : (
        <IonReactRouter>{items}</IonReactRouter>
      )}
    </IonApp>
  );
};

export default HomeApp;
