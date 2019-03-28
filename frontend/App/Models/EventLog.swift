//
//  EventLog.swift
//  app
//
//  Created by sunho on 2019/03/28.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import RealmSwift

class EventLog: Object, Codable {
    @objc dynamic var kind: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var payload: String = ""
}

class EventLogPayload: Codable {
    func kind() -> String {
        return ""
    }
}

// TODO make this enum somehow
class KnownWordPayload: EventLogPayload {
    var word: String = ""
    var n: Int = 0
    override func kind() -> String {
        return "known_word"
    }
}

class SkipUnknownDefinitionPayload: EventLogPayload {
    override func kind() -> String {
        return "skip_unknown_definition"
    }
}

class UnknownDefinitionPayload: EventLogPayload {
    var word: String = ""
    var defId: Int = 0
    var sentence: String = ""
    override func kind() -> String {
        return "unknown_definition"
    }
    enum CodingKeys: String, CodingKey
    {
        case word = "word"
        case defId = "def_id"
        case sentence = "sentence"
    }
}

class FlipPagePayload: EventLogPayload {
    var bookId: Int = 0
    var type: String = "epub"
    var interval: Double = 0
    var sentences: [Int] = []
    override func kind() -> String {
        return "flip_page"
    }
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case type = "type"
        case interval = "interval"
        case sentences = "sentences"
        case finishChapter = "finish_chapter"
        case finishBook = "finish_book"
    }
}

class UnknownWordQuizPayload: EventLogPayload {
    var word: String = ""
    var quality: Int = 0
    override func kind() -> String {
        return "unknown_word_quiz"
    }
}

class RecommendedBookRatePayload: EventLogPayload {
    var bookId: Int = 0
    var rate: Int = 0
    override func kind() -> String {
        return "recommended_book_rate"
    }
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case rate = "rate"
    }
}

class ViewShopBookPayload: EventLogPayload {
    var bookId: Int = 0
    override func kind() -> String {
        return "view_shop_book"
    }
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
    }
}
