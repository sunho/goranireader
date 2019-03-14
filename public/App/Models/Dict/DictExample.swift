import Foundation
import SQLite

fileprivate let examplesTable = Table("example")
fileprivate let defIdField = Expression<Int64>("definition_id")
fileprivate let firstField = Expression<String>("native")
fileprivate let secondField = Expression<String>("foreign")

class DictExample {
    var first: String
    var second: String
    
    init(first: String, second: String) {
        self.first = first
        self.second = second
    }

    class func fetch(connection: Connection, def: DictDefinition) {
        let query = examplesTable.where(defIdField == def.id)
        guard let results = try? connection.prepare(query) else {
            return
        }
        
        for result in results {
            do {
                def.examples.append(DictExample(first: try result.get(firstField), second: try result.get(secondField)))
            } catch {}
        }
    }
}
