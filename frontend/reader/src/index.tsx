import "react-app-polyfill/stable";
import "./index.css";
import "./fonts/lora-latin-400.woff"
import "./fonts/lora-latin-700.woff"
import "./fonts/noto-sans-kr-latin-400.woff"
import "./fonts/noto-sans-kr-latin-500.woff"
import "./fonts/noto-sans-kr-latin-700.woff"

import { Webapp } from "./bridge";
import React from "react";
import ReactDOM from "react-dom";
import Wrapper from "./components/Wrapper";
import styled, { createGlobalStyle } from "styled-components";

const GlobalStyle = createGlobalStyle`
  * {
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    -moz-tap-highlight-color: rgba(0, 0, 0, 0);
  }
  body {
    margin: 0;
    font-family: 'Lora', serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    font-size: 21px;
    user-select: none;
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -o-user-select: none;
  }
`;

window.webapp = new Webapp();
if (process.env.NODE_ENV === "development") {
  window.webapp.setDev();
}
if (navigator.userAgent === "ios") {
  window.webapp.setIOS();
}

ReactDOM.render(
  <div>
    <GlobalStyle/>
    <Wrapper/>
  </div>,
  document.getElementById("root")
);
