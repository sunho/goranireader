//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import RealmSwift

struct Book: Codable {
    let id: String
    let title: String
    let author: String
    let downloadLink: String
    let cover: String?
    let coverType: String?
    let chapters: [String: String]?
}

struct Rate: Codable {
    var rate: Double = 0
}
