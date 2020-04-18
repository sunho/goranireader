import React, { useContext } from "react";
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
