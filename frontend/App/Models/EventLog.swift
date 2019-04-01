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

protocol EventLogPayload: Codable {
    func kind() -> String
}

// TODO make this enum somehow
class KnownWordPayload: EventLogPayload {
    var word: String = ""
    var n: Int = 0
    func kind() -> String {
        return "known_word"
    }
}

class UnknownDefinitionPayload: EventLogPayload {
    var original: String = ""
    var word: String = ""
    var defId: Int?
    var sentence: String = ""
    var type: String = ""
    func kind() -> String {
        return "unknown_definition"
    }
    enum CodingKeys: String, CodingKey
    {
        case word = "word"
        case defId = "def_id"
        case sentence = "sentence"
        case type
        case original
    }
}

struct FlipPageUword: Codable {
    var index: Int = 0
    var interval: Double = 0
}

struct FlipPageSentence: Codable {
    var sentence: String = ""
    var uwords: [FlipPageUword] = []
}

class FlipPagePayload: EventLogPayload {
    var bookId: Int = 0
    var chapter: Int = 0
    var page: Int = 0
    var sentences: [FlipPageSentence] = []
    var type: String = "epub"
    var interval: Double = 0
    func kind() -> String {
        return "flip_page"
    }
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case chapter
        case page
        case type
        case interval
        case sentences
    }
}

class UnknownWordQuizPayload: EventLogPayload {
    var word: String = ""
    var quality: Int = 0
    func kind() -> String {
        return "unknown_word_quiz"
    }
}

class RecommendedBookRatePayload: EventLogPayload {
    var bookId: Int = 0
    var rate: Int = 0
    func kind() -> String {
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
    func kind() -> String {
        return "view_shop_book"
    }
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
    }
}
