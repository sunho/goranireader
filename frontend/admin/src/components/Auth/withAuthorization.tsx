import React, { useEffect, useState } from "react";
import { withRouter } from "react-router-dom";
import { compose } from "recompose";

import AuthUserContext from "./context";
import { withFirebase } from "../Firebase";

const withAuthorization = (Component: any) => {
  const Out: React.FC<any> = props => {
    const [authed, setAuthed] = useState(false);
    useEffect(() => {
      const listner = props.firebase.onAuthUserListener(
        (authUser: any) => {
          if (!authUser) {
            props.history.push("/login");
            return;
          }
          if (!authUser.admin) {
            props.history.push("/wait");
            return;
          }
          setAuthed(true);
        },
        () => props.history.push("/login")
      );
      return listner;
    }, []);
    return <>{authed ? <Component {...props} /> : null}</>;
  };

  return compose(
    withRouter,
    withFirebase
  )(Out);
};

export default withAuthorization;
