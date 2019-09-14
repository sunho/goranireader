//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import SQLite

fileprivate let defsTable = Table("defs")
fileprivate let idField = Expression<Int64>("id")
fileprivate let wordField = Expression<String>("word")
fileprivate let posField = Expression<String?>("pos")
fileprivate let defField = Expression<String>("def")

struct DictDefinition: Codable {
    var id: Int64
    var pos: POS?
    var def: String
    
    init(id: Int64, word: DictEntry, pos: POS?, def: String) {
        self.id = id
        self.pos = pos
        self.def = def
    }
    
    static func fetch(connection: Connection, entry: DictEntry, firstPos pos2: POS?, policy: DefSortPolicy?) -> [DictDefinition]? {
        let query = defsTable.where(wordField == entry.word)
            .order(posField, idField)
        guard let results = try? connection.prepare(query) else {
            return nil
        }
        
        var defs: [DictDefinition] = []
        
        for result in results {
            do {
                let defi = DictDefinition(id: try result.get(idField), word: entry, pos: POS(rawValue: try result.get(posField) ?? ""), def: try result.get(defField))
                
                if pos2 != nil && pos2 == defi.pos {
                    defs.insert(defi, at: 0)
                } else {
                    defs.append(defi)
                }
                
            } catch let error {
                print(error)
            }
        }
        
        if let policy = policy {
            defs = policy(entry.word, defs, pos2)
        }
        
        return defs
    }
}
