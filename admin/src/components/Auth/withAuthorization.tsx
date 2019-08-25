
import React from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import AuthUserContext from './context';
import { withFirebase } from '../Firebase';


const withAuthorization = (Component: any) => {
  class WithAuthorization extends React.Component<any,any> {
    listener: any
    componentDidMount() {
      this.listener = this.props.firebase.onAuthUserListener(
        (authUser: any) => {
          if (!authUser) {
            this.props.history.push('/login');
            return;
          }
          if (!authUser.admin) {
            this.props.history.push('/wait');
            return;
          }
        },
        () => this.props.history.push('/login'),
      );
    }

    componentWillUnmount() {
      this.listener();
    }

    render() {
      return (
        <AuthUserContext.Consumer>
          {authUser =>
            authUser ? <Component {...this.props} /> : null
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
