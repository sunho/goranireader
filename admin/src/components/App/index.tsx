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

const App: React.FC = () => (
  <BrowserRouter>
    <Route exact path="/" component={StudentPage} />
    <Route path="/mission" component={MissionPage} />
    <Route path="/progress" component={ProgressPage} />
    <Route path="/report" component={ReportPage} />
    <Route path="/login" component={LoginPage} />
    <Route path="/wait" component={WaitPage} />
    <Route path="/signup" component={SignUpPage} />
  </BrowserRouter>
);

export default App;