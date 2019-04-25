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
