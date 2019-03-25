import Foundation
import UIKit
import FolioReaderKit
import Kingfisher

struct Sens: Codable {
    var bookId: Int
    var name: String
    var rawCover: String
    var author: String
    var sentences: [SensSentence]
    
    var cover: Source {
        return Source.provider(Base64ImageDataProvider(base64String: rawCover, cacheKey: rawCover))
    }
    
    init(path: String) throws {
        self = try JSONDecoder().decode(Sens.self, from: NSData(contentsOfFile: path) as Data)
    }
    
    enum CodingKeys: String, CodingKey
    {
        case name
        case bookId = "book_id"
        case rawCover = "cover"
        case author
        case sentences
    }
}

struct SensSentence: Codable {
    var id: Int
    var text: String
    var answers: [String]
    var correctAnswer: Int
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case text
        case answers
        case correctAnswer = "correct_answer"
    }
}
