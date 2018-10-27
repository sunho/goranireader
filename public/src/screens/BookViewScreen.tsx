import * as React from 'react'
import { Epub, Streamer } from 'epubjs-rn'
import { Book } from '../store/books';

interface Props {
  book: Book
}

interface State {
  src: string
}

class BookViewScreen extends React.Component<Props, State> {
  streamer = new Streamer()

  constructor(props) {
    super(props)
    this.state = {
      src: ''
    }
  }

  componentDidMount() {
    this.streamer.start()
      .then(() => {
        return this.streamer.get('file://' + this.props.book.path)
      })
      .then(src => {
        this.setState({src: src})
      })
  }

  render() {
    const { src } = this.state
    return (
      <Epub
        src={src}
		    flow='scrolled'
      />
    )
  }
}

export default BookViewScreen
