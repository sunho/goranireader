import Foundation
import RealmSwift

class RealmService {
    static let shared = RealmService()
    fileprivate let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func getConfig() -> Config {
        if let config = realm.object(ofType: Config.self, forPrimaryKey: 1) {
            return config
        }
        write {
            realm.add(Config(), update: true)
        }
        return Config()
    }
    
    func getSensResult(bookId: Int, sensId: Int) -> SensResult {
        if let res = realm.object(ofType: SensResult.self, forPrimaryKey: "\(bookId)-\(sensId)") {
            return res
        }
        let res = SensResult()
        write {
            res.configure(bookId: bookId, sensId: sensId)
            realm.add(res, update: true)
        }
        return res
    }
    
    func getUnknownWord(_ word: String) -> UnknownWord {
        if let res = realm.object(ofType: UnknownWord.self, forPrimaryKey: word) {
            return res
        }
        let res = UnknownWord()
        write {
            res.word = word
            realm.add(res, update: true)
        }
        return res
    }
    
    func putUnknownWord(_ word: DictEntry, _ def: DictDefinition, _ tuple: UnknownDefinitionTuple) {
        let uw = getUnknownWord(word.word)
        let defs = uw.definitions.filter("id = %@", def.id)
        
        let uex = UnknownWordExample()
        uex.bookId = tuple.bookId
        uex.index = tuple.index
        uex.sentence = tuple.sentence
        
        if defs.count == 0 {
            let udef = UnknownWordDefinition()
            udef.id = Int(def.id)
            udef.def = def.def
            udef.examples.append(uex)
            write {
                uw.definitions.append(udef)
            }
        } else {
            let udef = defs.first!
            write {
                uw.ef = 2.5
                uw.repetitions = 0
                uw.update(.retry)
                if udef.examples.filter("sentence = %@", tuple.sentence).count == 0 {
                    udef.examples.append(uex)
                }
            }
        }
        NotificationCenter.default.post(name: .unknownWordAdded, object: nil)
    }
    
    func getTodayUnknownWords() -> Results<UnknownWord> {
        return realm.objects(UnknownWord.self).filter("nextReview <= %@", Date())
    }
    
    func getEpubProgress(_ bookId: Int) -> EpubProgress {
        if let res = realm.object(ofType: EpubProgress.self, forPrimaryKey: bookId) {
            return res
        }
        let res = EpubProgress()
        write {
            res.bookId = bookId
            realm.add(res, update: true)
        }
        return res
    }
    
    func getEventLogs() -> Results<EventLog> {
        return realm.objects(EventLog.self)
    }
    
    func clearEventLogs() {
        write {
            realm.delete(getEventLogs())
        }
    }
    
    func addEventLog<T: EventLogPayload>(_ payload: T)  {
        let log = EventLog()
        log.payload = String(data: try! JSONEncoder().encode(payload), encoding: .utf8)!
        log.time = Date()
        log.kind = payload.kind()
        write {
            realm.add(log)
        }
    }
    
    func write(_ block: (() throws -> Void)) {
        try! realm.write(block)
    }
}
