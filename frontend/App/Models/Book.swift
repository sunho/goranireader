//
//  Book.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import RealmSwift

struct Book: Codable {
    var id: Int = 0
    var name: String = ""
    var author: String = ""
    var isbn: String = ""
    var nativeName: String?
    var createdAt: String = ""
    var updatedAt: String = ""
    var cover: String = ""
    var desc: String = ""
    var rate: Float?
    var categories: [Category]?
    var epub: String?
    var sens: String?
    var quiz: String?
    var difficulty: Int?
    
    var types: [ContentType] {
        var out: [ContentType] = []
        if epub != nil {
            out.append(.epub)
        }
        if sens != nil {
            out.append(.sens)
        }
        return out
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case author
        case isbn
        case nativeName = "native_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cover
        case desc = "description"
        case rate
        case categories
        case epub
        case sens
        case quiz
        case difficulty
    }
}
