//
//  RecommendedBook.swift
//  app
//
//  Created by sunho on 16/04/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct RecommendedBook: Codable {
    var bookId: Int = 0
    var createdAt: Date
    var updatedAt: Date
    var rate: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "target_book_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
