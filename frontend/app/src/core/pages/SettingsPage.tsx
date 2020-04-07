import React, { useContext } from "react";
import {
  IonTabs,
  IonRouterOutlet,
  IonTabBar,
  IonTabButton,
  IonIcon,
  IonLabel,
  IonToolbar,
  IonTitle,
  IonList
} from "@ionic/react";
import { Route, Redirect } from "react-router";
import ReaderPage from "../../reader/pages/ReaderPage";
import BooksPage from "./BooksPage";
import { home, hammer } from "ionicons/icons";
import Layout from "../components/Layout";
import { storeContext } from "../stores/Context";
import { version } from "../../gorani";

const SettingsPage: React.FC = props => {
  const { userStore } = useContext(storeContext);
  const name = userStore.user.username;
  return (
    <Layout>
      <div>
        You are connected as <b>{name}</b>.
      </div>
      <div>Version: {version}</div>
    </Layout>
  );
};
export default SettingsPage;
