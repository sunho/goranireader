import * as React from 'react'
import { View, Text, ScrollView, Image, StyleSheet, TouchableOpacity } from 'react-native'
import { normalize, colorDivider, colorText, shadow, colorPrimary, colorWhite, colorLightPrimary, colorSecondText } from '../utils/StyleUtil'
import { Book } from '../store/books'
import DownloadCover from './DownloadCover'
import BookItem, { BookItemType } from './BookItem';
import { ApplicationState } from '../store';
import { connect } from 'react-redux';
import { Download, donwloadsReducer } from '../store/downloads';
import { startDownload } from '../store/downloads/actions';
import { Dispatch, bindActionCreators } from 'redux';
import { Navigator } from 'react-native-navigation';
import { bookViewScreen } from '../screens';

interface Props {
  books: Book[]
  downloads: { [id: number]: Download }
  startDownload: (book: Book) => void
  navigator: Navigator
}


class DownBooksList extends React.Component<Props> {
  bookPress(b: Book) {
    if (!this.props.downloads[b.id] && !b.path) {
      this.props.startDownload(b)
    } else if(b.path) {
      this.props.navigator.push(bookViewScreen(b))
    }
  }

  render() {
    const { books, downloads } = this.props

    return (
      <ScrollView style={styles.container}>
        {books.map(b => (
          <BookItem
            key={b.id}
            onPress={()=>{this.bookPress(b)}}
            type={BookItemType.DOWN}
            book={b}
            percent={downloads[b.id] ? downloads[b.id].percent : 0}
          />
        ))}
      </ScrollView>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  }
})

const mapStateToProps = (state: ApplicationState) => (
  {
    books: state.books.data,
    downloads: state.downloads.data,
  }
)

const mapDispatchToProps = (dispatch: Dispatch) => ({
  startDownload: (book: Book) => startDownload(dispatch, book)
})

export default connect(mapStateToProps, mapDispatchToProps)(DownBooksList)
