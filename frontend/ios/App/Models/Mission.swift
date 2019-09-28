//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Class: Codable {
    let name: String
    let mission: Mission?
}

struct Mission: Codable {
    let bookId: String?
    let id: String
    let message: String
    let due: Timestamp
    let chapters: [String]?
}
