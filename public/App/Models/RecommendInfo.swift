//
//  RecommendInfo.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct RecommendInfo: Codable {
    var targetBookId: Int
    var categories: [Category]
    
    enum CodingKeys: String, CodingKey
    {
        case targetBookId = "target_book_id"
        case categories
    }
}
