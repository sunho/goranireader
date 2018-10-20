import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView, ScrollView } from 'react-native';
import { normalize, colorLightPrimary } from '../../utils/StyleUtil';
import HeaderLayout from '../../components/HeaderLayout';
import BookItem from '../../components/BookItem';
import { Book } from '../../store/books';

interface Props {
  navigator: Navigator
}

class BooksListScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const books: Book[] = [
      {
        id: 32414,
        name: 'asdfasf',
        cover: 'asdffs',
        author: 'asdfasfd'
      },
      {
        id: 32414,
        name: 'asdfasf',
        cover: 'https://images-na.ssl-images-amazon.com/images/I/61GPmyCxTpL._SX331_BO1,204,203,200_.jpg',
        author: 'asdfasfd'
      }
    ]
    return (
      <HeaderLayout title='책'>
        <ScrollView style={styles.container}>
          {
            books.map(b => {
              return (
                <BookItem book={b}></BookItem>
              )
            })
          }
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

export default BooksListScreen
