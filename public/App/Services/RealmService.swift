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
        setConfig(Config())
        return Config()
    }
    
    func setConfig(_ config: Config) {
        try! realm.write {
            realm.add(config, update: true)
        }
    }
    
    func write(_ block: (() throws -> Void)) {
        try! realm.write(block)
    }
}
