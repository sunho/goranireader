import { Navigation } from 'react-native-navigation'
import { Store } from 'redux'
import LoginScreen from './LoginScreen';
import { ApplicationState } from '../store';


const appName = 'gorani'
const loginName = `${appName}.login`

export function registerScreens(store: Store<ApplicationState>, provider: any) {
  Navigation.registerComponent(loginName, () => LoginScreen, store, provider)
}

export function showLoginScreen() {
  Navigation.startSingleScreenApp(
    {
      screen: {
        screen: loginName,
        title: 'Login',
        navigatorStyle: {
          navBarHidden: true
        }
      }
    }
  )
}
