//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

struct RecommendedBook: Codable {
    var bookId: Int = 0
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var rate: Int? = 0
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case rate
    }
}
