import Foundation
import SQLite

fileprivate let table = Table("unknown_words")
fileprivate let idField = Expression<Int64>("id")
fileprivate let addedDateField = Expression<Date>("added_date")
fileprivate let wordField = Expression<String>("word")
fileprivate let defField = Expression<String>("def")


fileprivate let UnknownWordbookId: Int64 = 1

enum WordbookEntryFilter {
    case day(Range<Date>)
    case word(String)
    case book(String)
}

class UnknownWord {
    var id: Int64?
    var addedDate: Date
    var word: String
    var def: String
    
    init(word: String, def: String) {
        self.word = word
        self.def = def
        self.addedDate = Date()
    }
    
    class func get() -> [UnknownWord] {
        let query = table.order(addedDateField.desc)
        
        guard let results = try? UserData.shared.connection.prepare(query) else {
            return []
        }
            
        var words: [UnknownWord] = []
        for result in results {
            do{
                let word = UnknownWord(word: try result.get(wordField), def: try result.get(defField))
                word.id = try result.get(idField)
                word.addedDate = try result.get(addedDateField)
                words.append(word)
            } catch {}
        }
        
        return words
    }

    func add() throws {
        self.id = try UserData.shared.connection.run(table.insert(
            addedDateField <- self.addedDate,
            wordField <- self.word,
            defField <- self.def
        ))
    }
    
    class func prepare(_ connection: Connection) throws {
        try connection.run(table.create(ifNotExists: true) { t in
            t.column(idField, primaryKey: true)
            t.column(defField)
            t.column(wordField)
            t.column(addedDateField)
        })
        try connection.run(table.createIndex(addedDateField, unique: false, ifNotExists: true))
        try connection.run(table.createIndex(wordField, defField, unique: true, ifNotExists: true))
        try connection.run(table.createIndex(wordField, unique: false, ifNotExists: true))
    }
}
