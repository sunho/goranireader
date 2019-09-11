//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

class EventLog: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var payload: String = ""
}

struct ELPaginatePayload: Codable {
    let bookId: String
    let chapterId: String
    let time: Int
    let sids: [String]
    let wordUnknowns: [PaginateWordUnknown]
    let sentenceUnknowns: [PaginateSentenceUnknown]
}

struct PaginateWordUnknown: Codable {
    let sentenceId: String
    let word: String
    let wordIndex: Int
    let time: Int
}

struct PaginateSentenceUnknown: Codable {
    let sentenceId: String
    let time: Int
}
