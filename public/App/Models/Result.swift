//
//  Result.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct SensResult: Codable {
    var bookId: Int
    var sensId: Int
    var score: Int
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case sensId = "sens_id"
        case score
    }
}

struct QuizResult: Codable {
    var bookId: Int
    var quizId: Int
    var score: Int
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case quizId = "quiz_id"
        case score
    }
}

