import { Router, Route, Switch, Redirect } from "react-router";
import React from "react";
import { BrowserRouter } from "react-router-dom";
import StudentPage from "../StudentPage";
import ReportPage from "../ReportPage";
import LoginPage from "../LoginPage";
import SignUpPage from "../SignUpPage";
import WaitPage from "../WaitPage";
import withAuthentication from "../Auth/withAuthentication";
import Layout from "../Layout";
import withAuthorization from "../Auth/withAuthorization";
import NotFound from "../NotFound";
import { MuiThemeProvider, createMuiTheme } from "@material-ui/core";
import PerformancePage from "../PerformancePage";
import PerformanceDetailPage from "../PerformanceDetailPage";

const Dashboard: React.FC<any> = ({ match }) => (
  <Layout>
    <Switch>
      <Route exact path={`${match.url}/`} component={StudentPage} />
      <Route path={`${match.url}/performance`} component={PerformancePage} />
      <Route path={`${match.url}/performanceDetail/:userId`} component={PerformanceDetailPage} />
      <Route path={`${match.url}/report`} component={ReportPage} />
      <Route component={NotFound} />
    </Switch>
  </Layout>
);

const theme = createMuiTheme({
  palette: {
    primary: {
      main: "#AB7756"
    }
  },
  overrides: {
    MuiTableCell: {
      paddingCheckbox: {
        padding: "14px 40px 14px 16px"
      }
    }
  }
});

const App: React.FC = () => (
  <MuiThemeProvider theme={theme}>
    <BrowserRouter>
      <Switch>
        <Redirect path="/" exact={true} to="/dashboard" />
        <Route path="/dashboard" component={withAuthorization(Dashboard)} />
        <Route path="/login" component={LoginPage} />
        <Route path="/wait" component={WaitPage} />
        <Route path="/signup" component={SignUpPage} />
        <Route component={NotFound} />
      </Switch>
    </BrowserRouter>
  </MuiThemeProvider>
);

export default withAuthentication(App);
