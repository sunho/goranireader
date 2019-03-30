import Foundation
import SQLite

class DictService {
    fileprivate static let dictURL: URL = {
        let path = Bundle.main.path(forResource: "dict", ofType: "db")!
        return URL(string: path)!
    }()
    
    static let shared = DictService(url: dictURL)
    
    let connection: Connection
    
    var defSortPolicy: DefSortPolicy?

    private init(url: URL) {
        self.connection = try! Connection(url.path)
    }
    
    func get(word: String, firstDefPos: POS? = nil) -> DictEntry? {
        return DictEntry.get(connection: connection, word: word, firstDefPos: firstDefPos, policy: self.defSortPolicy)
    }
    
    func search(word: String, firstDefPos: POS? = nil) -> [DictEntry] {
        return DictEntry.search(connection: connection, word: word, firstDefPos: firstDefPos, policy: self.defSortPolicy)
    }
}
