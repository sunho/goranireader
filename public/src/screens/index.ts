import { Navigation } from 'react-native-navigation'
import { Store } from 'redux'
import LoginScreen from './LoginScreen';
import { ApplicationState } from '../store';
import BooksListScreen from './MainScreen/BooksListScreen';
import { colorDivider, colorWhite, colorPrimary, normalize } from '../utils/StyleUtil';


const appName = 'gorani'
const loginName = `${appName}.login`
const mainName = `${appName}.main`

export function registerScreens(store: Store<ApplicationState>, provider: any) {
  Navigation.registerComponent(loginName, () => LoginScreen, store, provider)
  Navigation.registerComponent(`${mainName}.booksList`, () => BooksListScreen, store, provider)
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

export function showMainScreen() {
  Navigation.startTabBasedApp(
    {
      tabs: [
        {
          icon: require('../../assets/tab_book.png'),
          screen: `${mainName}.booksList`,
          navigatorStyle: {
            navBarHidden: true
          }
        },
      ],
      tabsStyle: {
        tabBarButtonColor: colorPrimary,
        tabBarSelectedButtonColor: colorPrimary,
        tabBarBackgroundColor: colorWhite
      },
    }
  )
}
