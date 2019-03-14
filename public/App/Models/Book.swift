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
    var isbn: String = ""
    var nativeName: String?
    var createdAt: Date
    var updatedAt: Date
    var cover: String
    var desc: String
    var rate: Int
    var categories: [Category]
    var epub: String?
    var sens: String?
    var quiz: String?
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case name
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
    }
}
