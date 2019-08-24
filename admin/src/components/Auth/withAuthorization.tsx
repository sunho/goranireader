
import React from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import AuthUserContext from './context';
import { withFirebase } from '../Firebase';


const withAuthorization = (Component: any) => {
  class WithAuthorization extends React.Component<any,any> {
    render() {
      return (
        <AuthUserContext.Consumer>
          {authUser =>
            (authUser && authUser!.admin === true )? <Component {...this.props} /> : null
          }
        </AuthUserContext.Consumer>
      );
    }
  }

  return compose(
    withRouter,
    withFirebase,
  )(WithAuthorization);
};

export default withAuthorization;
