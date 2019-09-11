//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

class SensProgress: Object {
    @objc dynamic var bookId: Int = 0
    @objc dynamic var sensId: Int = 0
    @objc dynamic var progress: Float = 0
    @objc dynamic var updatedAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "bookId"
    }
}

class BookProgress: Object {
    @objc dynamic var bookId: String = ""
    @objc dynamic var offsetX: Float = 0
    @objc dynamic var offsetY: Float = 0
    @objc dynamic var progress: Float = 0
    @objc dynamic var pageNumber: Int = 0
    @objc dynamic var updatedAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "bookId"
    }
}
