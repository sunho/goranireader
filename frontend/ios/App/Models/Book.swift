//
// Copyright © 2019 Sunho Kim. All rights reserved.
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
    var googleId: String = ""
    var desc: String = ""
    var epub: String?
    
    var types: [ContentType] {
        var out: [ContentType] = []
        if epub != nil {
            out.append(.epub)
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
        case googleId = "google_id"
        case epub
    }
}

struct Rate: Codable {
    var rate: Double = 0
}
