import * as React from 'react'
import { registerScreens, showLoginScreen } from './screens'
import { configureStore, ApplicationState } from './store'
import { Provider } from 'react-redux'

const store = configureStore()
registerScreens(store, Provider)

export default class App extends React.Component {
  constructor(props: any) {
    super(props);
    store.subscribe(this.onStoreUpdate.bind(this));
    this.onStoreUpdate()
  }

  onStoreUpdate() {
    const { logined } = store.getState().auth;
    if ( !logined ) {
      showLoginScreen()
    }
  }
}
