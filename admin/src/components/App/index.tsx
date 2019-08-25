import { Router, Route } from "react-router";
import React from "react";
import { BrowserRouter } from "react-router-dom";
import StudentPage from "../StudentPage";
import MissionPage from "../MissionPage";
import ProgressPage from "../ProgressPage";
import ReportPage from "../ReportPage";
import LoginPage from "../LoginPage";
import SignUpPage from "../SignUpPage";
import WaitPage from "../WaitPage";
import withAuthentication from "../Auth/withAuthentication";
import Layout from "../Layout";
import withAuthorization from "../Auth/withAuthorization";

const Dashboard: React.FC<any> = ({ match }) => (
    <Layout>
        <Route exact path={`${match.url}/`} component={StudentPage} />
        <Route path={`${match.url}/mission`} component={MissionPage} />
        <Route path={`${match.url}/progress`} component={ProgressPage} />
        <Route path={`${match.url}/report`} component={ReportPage} />
    </Layout>
)

const App: React.FC = () => (
  <BrowserRouter>
    <Route path="/dashboard" component={withAuthorization(Dashboard)} />
    <Route path="/login" component={LoginPage} />
    <Route path="/wait" component={WaitPage} />
    <Route path="/signup" component={SignUpPage} />
  </BrowserRouter>
);

export default withAuthentication(App);