//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import SQLite

fileprivate let wordsTable = Table("words")
fileprivate let wordField = Expression<String>("word")
fileprivate let pronField = Expression<String?>("pron")

typealias DefSortPolicy = (_ word: String, _ entries: [DictDefinition], _ pos: POS?) -> [DictDefinition]

// TODO separate
struct DictEntry: Codable {
    var word: String
    var pron: String
    var defs: [DictDefinition] = []
    
    init(word: String, pron: String) {
        self.word = word
        self.pron = pron.unstressed
    }
    
    static func get(connection: Connection, word wordstr: String, firstDefPos: POS?, policy: DefSortPolicy?) -> DictEntry? {
        let query = wordsTable.where(wordField.collate(.nocase) == wordstr)
        
        do {
            if let entry = try connection.pluck(query) {
                var entry = DictEntry(word: try entry.get(wordField), pron: try entry.get(pronField) ?? "")
                
                let defs = DictDefinition.fetch(connection: connection, entry: entry, firstPos: firstDefPos, policy: policy)
                entry.defs = defs ?? []
                return entry
            }
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    static func search(connection: Connection, word: String, firstDefPos: POS?, policy: DefSortPolicy?) -> [DictEntry] {
        if word == "" {
            return []
        }
        
        var entries: [DictEntry] = []
        let word = SentenceUtil.removePunctuations(word)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let candidates = word.baseCandidates
        for candidate in candidates {
            if let entry = DictEntry.get(connection: connection, word: candidate, firstDefPos: firstDefPos, policy: policy) {
                entries.append(entry)
            }
        }
        
        return entries
    }
}
