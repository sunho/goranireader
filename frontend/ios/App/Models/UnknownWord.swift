//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

public enum CardAnswerQuality: String {
    case easy = "쉬움"
    case medium = "중간"
    
    case difficult = "어려움"
    case retry = "멍~"
}

extension CardAnswerQuality {
    var value: Float {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 4
        case .difficult:
            return 2
        case .retry:
            return 0
        }
    }
}


class UnknownWord: Object, Codable {
    @objc dynamic var word: String = ""
    @objc dynamic var memory: String = ""
    @objc dynamic var ef: Float = 2.5
    @objc dynamic var nextReview: Date = Date().noon
    @objc dynamic var repetitions: Int = 0
    
    var definitions = List<UnknownWordDefinition>()
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
    func update(_ quality: CardAnswerQuality) {
        let q = quality.value
        if q < 3 {
            repetitions = 0
        } else {
            repetitions = repetitions + 1
            ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
            if ef < 1.3 {
                ef = 1.3
            }
        }
        nextReview = nextReview.addingDays(Int(interval(repetitions, ef)))
    }
    
    func interval(_ repetitions: Int, _ ef: Float) -> Float {
        if repetitions == 0 {
            return 0
        }
        if repetitions == 1 {
            return 1
        }
        if repetitions == 2 {
            return 6
        }
        return interval(repetitions - 1, ef) * ef
    }
}

class UnknownWordDefinition: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var def: String = ""
    var examples = List<UnknownWordExample>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class UnknownWordExample: Object, Codable {
    @objc dynamic var sentence: String = ""
    @objc dynamic var bookId: Int = 0
    @objc dynamic var index: Int = 0
    @objc dynamic var original: String = ""
}

typealias UnknownDefinitionTuple = (word: String, bookId: Int, sentence: String, index: Int)
