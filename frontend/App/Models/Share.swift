//
//  Share.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
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
