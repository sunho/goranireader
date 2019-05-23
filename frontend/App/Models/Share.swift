//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

class Share: Codable {
    var id: Int = 0
    var userId: Int = 0
    var upParagraph: String = ""
    var downParagraph: String = ""
    var sentence: String = ""
    var createdAt: String = ""
}

class SharedCommend: Codable {
    var id: Int = 0
    var shareId: Int = 0
    var userId: Int = 0
    var content: String = ""
    var rate: Int = 0
}
