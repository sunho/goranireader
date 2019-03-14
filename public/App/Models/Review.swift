//
//  Review.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct Review: Codable {
    var id: Int
    var userId: Int
    var content: String
    var rate: Int
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case userId = "user_id"
        case content
        case rate
    }
}
