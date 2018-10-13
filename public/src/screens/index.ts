import { Navigation } from 'react-native-navigation'
import { Store } from 'redux'
import AuthScreen from './AuthScreen';
import { ApplicationState } from '../store';


const appName = 'gorani'
const authName = `${appName}.auth`

export function registerScreens(store: Store<ApplicationState>, provider: any) {
  Navigation.registerComponent(authName, () => AuthScreen, store, provider)
}

export function showAuthScreen() {
  Navigation.startSingleScreenApp(
    {
      screen: {
        screen: authName,
        title: 'Login',
        navigatorStyle: {
          navBarHidden: true
        }
      }
    }
  )
}
