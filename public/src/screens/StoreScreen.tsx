import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView, ScrollView } from 'react-native';
import { normalize, colorLightPrimary } from '../utils/StyleUtil';
import HeaderLayout from '../components/HeaderLayout';
import BookItem from '../components/BookItem';
import { Book } from '../store/books';
import { ApplicationState } from '../store';
import { connect } from 'react-redux';
import { storeDetailScreen } from '.';

interface Props {
  navigator: Navigator
  ownBooks: Book[]
}

interface State {
  keyword: string
  books: Book[]
}

class StoreScreen extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props)
    this.state = {
      keyword: '',
      books: [
        {
          id: 32414,
          name: 'asdfasf',
          cover: 'https://images-na.ssl-images-amazon.com/images/I/61GPmyCxTpL._SX331_BO1,204,203,200_.jpg',
          author: 'asdfasfd'
        }
      ]
    }
  }


  showDetail(book: Book) {
    const { navigator } = this.props
    navigator.push(storeDetailScreen(book))
  }

  render() {
    const { books } = this.state
    return (
      <HeaderLayout title='서점'>
        <ScrollView style={styles.container}>
          {books.map(b => (
            <BookItem onPress={()=>{this.showDetail(b)}} book={b}></BookItem>
          ))}
        </ScrollView>
      </HeaderLayout>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colorLightPrimary
  }
})

const mapStateToProps = (state: ApplicationState) => (
  {
    ownBooks: state.books.data
  }
)

export default connect(mapStateToProps)(StoreScreen)
