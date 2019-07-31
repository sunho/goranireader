//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Config: Object {
    @objc dynamic var id = 1
    @objc dynamic var token = ""
    @objc dynamic var authorized = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
