//
//  File.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct SensProgress: Codable {
    var bookId: Int
    var sensId: Int
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case sensId = "sens_id"
    }
}

struct QuizProgress: Codable {
    var bookId: Int
    var quizId: Int
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case quizId = "quiz_id"
    }
}
