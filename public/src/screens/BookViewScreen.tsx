import * as React from 'react'
import { Epub } from 'epubjs-rn'

class BookViewScreen extends React.Component {
  render() {
    return (
      <Epub
        src='https://s3.amazonaws.com/epubjs/books/moby-dick/OPS/package.opf'
		    flow='scrolled'
      />
    )
  }
}

export default BookViewScreen
