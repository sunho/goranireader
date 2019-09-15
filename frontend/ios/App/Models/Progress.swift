//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

class BookProgress: Object {
    @objc dynamic var bookId: String = ""
    @objc dynamic var progress: Float = 0
    @objc dynamic var readingQuestion: String = ""
    @objc dynamic var readingSentence: String = ""
    @objc dynamic var readingChapter: String = ""
    @objc dynamic var updatedAt: Date = Date()
    @objc dynamic var quiz: Bool = false
    var solvedChapers: List<String> = List()
    
    override static func primaryKey() -> String? {
        return "bookId"
    }
}
