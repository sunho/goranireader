//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

struct Progress: Codable {
    var readPages: Int = 0
    enum CodingKeys: String, CodingKey
    {
        case readPages = "read_pages"
    }
}

struct Mission: Codable {
    var id: Int = 0
    var classId: Int = 0
    var pages: Int = 0
    var createdAt: Date
    var updatedAt: Date
    var startAt: Date
    var endAt: Date
    enum CodingKeys: String, CodingKey
    {
        case id
        case classId = "class_id"
        case pages = "pages"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case startAt = "start_at"
        case endAt = "end_at"
    }
}
