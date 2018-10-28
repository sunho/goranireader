import { Navigation } from 'react-native-navigation'
import { Store } from 'redux'
import LoginScreen from './LoginScreen';
import { ApplicationState } from '../store';
import DownBooksListScreen from './DownBooksListScreen';
import { colorDivider, colorWhite, colorPrimary, normalize, colorSecondText } from '../utils/StyleUtil';
import BookViewScreen from './BookViewScreen';
import StoreScreen from './StoreScreen';
import StoreDetailScreen from './StoreDetailScreen';
import { Book } from '../store/books';


const appName = 'gorani'

const bookView = `bookView`

const login = `${appName}.login`

const main = `${appName}.main`
const mainBooksList = `${main}.booksList`
const mainStore = `${main}.store`
const mainStoreDetail = `${mainStore}.detail`

export function registerScreens(store: Store<ApplicationState>, provider: any) {
  Navigation.registerComponent(login, () => LoginScreen, store, provider)

  Navigation.registerComponent(bookView, () => BookViewScreen, store, provider)

  Navigation.registerComponent(mainBooksList, () => DownBooksListScreen, store, provider)
  Navigation.registerComponent(mainStore, () => StoreScreen, store, provider)
  Navigation.registerComponent(mainStoreDetail, () => StoreDetailScreen, store, provider)
}

export function showLoginScreen() {
  Navigation.startSingleScreenApp(
    {
      screen: {
        screen: login,
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
          icon: require('../../assets/book.png'),
          label: '책',
          screen: mainBooksList,
          navigatorStyle: {
            navBarHidden: true,
          }
        },
        {
          icon: require('../../assets/book.png'),
          label: '서점',
          screen: mainStore,
          navigatorStyle: {
            navBarHidden: true,
          }
        },
      ],
      tabsStyle: {
        tabBarButtonColor: colorDivider,
        tabBarSelectedButtonColor: colorPrimary,
        tabBarBackgroundColor: colorWhite,
        tabBarHideShadow: true
      },
    }
  )
}

export function storeDetailScreen(book: Book) {
  return {
    screen: mainStoreDetail,
    passProps: {
      book: book
    },

    title: book.name
  }
}

export function bookViewScreen(book: Book) {
  return {
    screen: bookView,
    passProps: {
      book: book
    },
    title: book.name,
    navigatorStyle: {
      navBarHidden: true,
      disabledBackGesture: false,
      disabledSimultaneousGesture: false
    }
  }
}
