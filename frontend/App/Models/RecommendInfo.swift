//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

struct RecommendInfo: Codable {
    var targetBookId: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case targetBookId = "target_book_id"
    }
}

struct TargetBookProgress: Codable {
    var bookId: Int = 0
    var progress: Double = 0
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case progress
    }
}
