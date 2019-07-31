//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

struct Memory: Codable {
    var id: Int?
    var userId: Int?
    var sentence: String = ""
    var rate: Float?
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case userId = "user_id"
        case sentence
        case rate
    }
}

struct SimilarWord: Codable {
    var word: String = ""
    var score: Int = 0
}
