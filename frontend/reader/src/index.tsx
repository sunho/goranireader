import "react-app-polyfill/stable";
import "./index.css";
import { Webapp } from "./bridge";
import React from "react";
import ReactDOM from "react-dom";
import ReaderWrapper from "./components/ReaderWrapper";
import styled, { createGlobalStyle } from "styled-components";

const GlobalStyle = createGlobalStyle`
  body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
      'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
      sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  code {
    font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
      monospace;
  }
`;

window.webapp = new Webapp();
if (process.env.NODE_ENV === "development") {
  window.webapp.setDev();
}

ReactDOM.render(
  <div>
    <GlobalStyle/>
    <ReaderWrapper/>
  </div>,
  document.getElementById("root")
);
