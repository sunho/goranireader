import Foundation
import SQLite
import SwiftSoup
import Regex

fileprivate let table = Table("known_words")
fileprivate let wordField = Expression<String>("word")
fileprivate let specialPat = "[^1-9a-zA-Z-\\s]".r!
fileprivate let lowerPat = "[a-z-]+".r!

class KnownWord {
    var word: String

    init(word: String) {
        self.word = word
    }

    class func get(word: String) -> KnownWord? {
        let query = table.where(wordField == word)
        
        do {
            if let known = try UserData.shared.connection.pluck(query) {
                return KnownWord(word: try known.get(wordField))
            }
        } catch {}
        
        return nil
    }
    
    func add() throws {
        do {
            try UserData.shared.connection.run(table.insert( wordField <- self.word ))
        } catch let Result.error(_, code, _) where code == SQLITE_CONSTRAINT {} // ignore unique contraint error
    }
    
    class func add(html: String) throws {
        var set = Set<String>()
        getWordsFromHTML(set: &set, html: html)
        
        for word in set {
            try addWithVariants(word: word)
            let candidates = VerbType.candidates(word: word).filter { $0.1 != .past && $0.1 != .complete }
            for candidate in candidates {
                try addWithVariants(word: candidate.0)
            }
        }
    }
    
    class fileprivate func addWithVariants(word: String) throws {
        for variant in ["", "ing", "s", "es", "ed", "d"] {
            try KnownWord(word: word + variant).add()
        }
    }
    
    class func getWordsFromHTML(set: inout Set<String>, html: String) {
        do {
            let doc = try SwiftSoup.parse(html)
            let ps = try doc.select("p")
            try ps.select("chunk").remove()
            
            for ele in ps.array() {
                let text = try ele.text()
                let replaced = specialPat.replaceAll(in: text, with: "")
                let words = replaced.components(separatedBy: " ")
                
                for i in 0..<words.count {
                    // exclude common noun
                    if lowerPat.matches(words[i]) || i == 0 {
                        set.insert(words[i].lowercased())
                    }
                }
            }
        } catch {}
    }

    func delete() throws {
        let me = table.where(wordField == self.word)
        try UserData.shared.connection.run(me.delete())
    }
    
    class func prepare(_ connection: Connection) throws {
        try connection.run(table.create(ifNotExists: true) { t in
            t.column(wordField, unique: true)
        })
    }
}
