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
        RealmService.shared.write {
            realm.add(Config(), update: true)
        }
        return Config()
    }
    
    func getSensResult(bookId: Int, sensId: Int) -> SensResult {
        if let res = realm.object(ofType: SensResult.self, forPrimaryKey: "\(bookId)-\(sensId)") {
            return res
        }
        let res = SensResult()
        RealmService.shared.write {
            res.configure(bookId: bookId, sensId: sensId)
            realm.add(res, update: true)
        }
        return res
    }
    
    func write(_ block: (() throws -> Void)) {
        try! realm.write(block)
    }
}
