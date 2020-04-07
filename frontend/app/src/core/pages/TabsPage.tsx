import React from "react";
import {
  IonTabs,
  IonRouterOutlet,
  IonTabBar,
  IonTabButton,
  IonIcon,
  IonLabel,
  IonToolbar,
  IonTitle
} from "@ionic/react";
import { Route, Redirect } from "react-router";
import BooksPage from "./BooksPage";
import { home, hammer } from "ionicons/icons";
import SettingsPage from "./SettingsPage";

const TabsPage: React.FC = props => (
  <IonTabs>
    <IonRouterOutlet>
      <Route path="/main/:tab(home)" component={BooksPage} />
      <Route path="/main/:tab(settings)" component={SettingsPage} />
      <Route exact path="/main" render={() => <Redirect to="/main/home" />} />
    </IonRouterOutlet>
    <IonTabBar slot="bottom">
      <IonTabButton tab="home" href="/main/home">
        <IonIcon icon={home} />
        <IonLabel>Home</IonLabel>
      </IonTabButton>
      <IonTabButton tab="settings" href="/main/settings">
        <IonIcon icon={hammer} />
        <IonLabel>Settings</IonLabel>
      </IonTabButton>
    </IonTabBar>
  </IonTabs>
);

export default TabsPage;
