import Foundation
import SQLite

class UserData {
    var connection: Connection
    
    static let shared = UserData(url: FileUtill.userDataURL)
    
    private init(url: URL) {
        self.connection = try! Connection(url.path)
        try! KnownWord.prepare(self.connection)
        try! UnknownWord.prepare(self.connection)
    }
}
