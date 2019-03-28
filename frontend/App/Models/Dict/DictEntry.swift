import Foundation
import SQLite

fileprivate let wordsTable = Table("words")
fileprivate let wordField = Expression<String>("word")
fileprivate let pronField = Expression<String?>("pron")

typealias DefSortPolicy = (_ word: String, _ entries: [DictDefinition], _ pos: POS?) -> [DictDefinition]

// TODO separate
class DictEntry {
    var word: String
    var pron: String
    var defs: [DictDefinition] = []
    
    init(word: String, pron: String) {
        self.word = word
        self.pron = pron.unstressed
    }
    
    class func get(connection: Connection, word wordstr: String, firstDefPos: POS?, policy: DefSortPolicy?) -> DictEntry? {
        let query = wordsTable.where(wordField.collate(.nocase) == wordstr)
        
        do {
            if let entry = try connection.pluck(query) {
                let entry = DictEntry(word: try entry.get(wordField), pron: try entry.get(pronField) ?? "")
                
                DictDefinition.fetch(connection: connection, entry: entry, firstPos: firstDefPos, policy: policy)
                return entry
            }
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    
    class func search(connection: Connection, word: String, firstWordType: VerbType?, firstDefPos: POS?, policy: DefSortPolicy?) -> [DictEntry] {
        if word == "" {
            return []
        }
        
        var entries: [DictEntry] = []
        let word = SentenceUtil.removePunctuations(word)
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let candidates = word.verbCandidates
        for candidate in candidates {
            if let entry = DictEntry.get(connection: connection, word: candidate.0, firstDefPos: firstDefPos, policy: policy) {
                if candidate.1 == firstWordType {
                    entries.insert(entry, at: 0)
                } else {
                    entries.append(entry)
                }
            }
        }

        if let entry = DictEntry.get(connection: connection, word: word, firstDefPos: firstDefPos, policy: policy) {
            entries.append(entry)
        }
        
        return entries
    }
}
