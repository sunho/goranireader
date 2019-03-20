//
//  Result.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import RealmSwift

class SensResult: Object, Codable {
    @objc dynamic var bookId: Int = 0
    @objc dynamic var sensId: Int = 0
    @objc dynamic var back: Bool = false
    @objc dynamic var answer: Int = -1
    @objc dynamic var score: Int = -1
    @objc dynamic var compoundKey: String = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func configure(bookId: Int, sensId: Int){
        self.bookId = bookId
        self.sensId = sensId
        self.compoundKey = "\(bookId)-\(sensId)"
    }
    
    enum CodingKeys: String, CodingKey
    {
        case bookId = "book_id"
        case sensId = "sens_id"
        case back
        case answer
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

