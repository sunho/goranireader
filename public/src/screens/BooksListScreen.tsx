import * as React from 'react'
import { Navigator } from 'react-native-navigation';
import { View, Text, StyleSheet, KeyboardAvoidingView, ScrollView } from 'react-native';
import { normalize, colorLightPrimary } from '../utils/StyleUtil';
import HeaderLayout from '../components/HeaderLayout';
import BookItem from '../components/BookItem';
import { Book } from '../store/books';
import { ApplicationState } from '../store';
import { connect } from 'react-redux';

interface Props {
  navigator: Navigator
  books: Book[]
}

class BooksListScreen extends React.Component<Props> {
  constructor(props: Props) {
    super(props)
  }

  render() {
    const { books } = this.props
    return (
      <HeaderLayout title='책'>
        <ScrollView style={styles.container}>
          {books.map(b => (
            <BookItem book={b}></BookItem>
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
    books: state.books.data
  }
)

export default connect(mapStateToProps)(BooksListScreen)
