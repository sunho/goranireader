import StaticServer from 'react-native-static-server'
import { rootPath, epubPath } from './fs'

export default class ContentStreamer {
  public port = '3' + Math.round(Math.random() * 1000)
  public origin = 'files://'
  private server = new StaticServer(this.port, rootPath, { localOnly: true })

  start() {
    return this.server.start().then(url => {
      this.origin = url
      return url
    })
  }

  stop() {
    this.server.stop()
  }

  kill() {
    this.server.kill()
  }

  epubPath(book: Book) {
    return this.origin + '/' + epubPath(book)
  }
}
