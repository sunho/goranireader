//
//  Memory.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
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
