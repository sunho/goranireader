import * as React from 'react'
import { Epub } from 'epubjs-rn'
import { Book } from '../store/books';
import { ContentStreamer } from '../modules/content';
import { View, StyleSheet } from 'react-native';

interface Props {
  book: Book
}

interface State {
  src: string
  origin: string
}

class BookViewScreen extends React.Component<Props, State> {
  streamer = new ContentStreamer()

  constructor(props) {
    super(props)
    this.state = {
      src: '',
      origin: ''
    }
  }

  componentDidMount() {
    this.streamer.start()
    .then(origin => {
      const src = this.streamer.epubPath(this.props.book)
      this.setState({src: src, origin: origin})
    })
  }

  render() {
    const { origin, src } = this.state
    return (
      <View style={styles.container}>
        <Epub
          style={styles.epub}
          flow='paginated'
          src={src}
          origin={origin}
          onError={message => {
            console.error("EPUBJS-Webview", message);
          }}
        />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  epub: {
    flex: 1,
    alignSelf: 'stretch',
  }
})

export default BookViewScreen
