//
// Copyright © 2019 Sunho Kim. All rights reserved.
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
