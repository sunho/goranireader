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
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct EventLogMap: Codable {
    let type: String
    let time: Date
    let payload: String
}

protocol EventLogPayload: Codable {
    static func type() -> String
}

struct ELPaginatePayload: EventLogPayload {
    let bookId: String
    let chapterId: String
    let time: Int
    let sids: [String]
    let wordUnknowns: [PaginateWordUnknown]
    let sentenceUnknowns: [PaginateSentenceUnknown]
    
    static func type() -> String {
        return "paginate"
    }
}

struct ELUnknownSentencePayload: EventLogPayload {
    let bookId: String
    let chapterId: String
    let sentenceId: String
    
    static func type() -> String {
        return "unknown_sentence"
    }
}

struct ELSubmitQuestionPayload: EventLogPayload {
    let bookId: String
    let chapterId: String
    let questionId: String
    let option: String
    let right: Bool
    let time: Int
    
    static func type() -> String {
        return "submit_question"
    }
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
