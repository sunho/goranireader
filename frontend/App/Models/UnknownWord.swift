//
//  UnknownWord.swift
//  app
//
//  Created by sunho on 2019/03/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import RealmSwift

class UnknownWord: Object, Codable {
    @objc dynamic var word: String = ""
    @objc dynamic var memory: String = ""
    var definitions = List<UnknownWordDefinition>()
    
    override static func primaryKey() -> String? {
        return "word"
    }
}

class UnknownWordDefinition: Object, Codable {
    @objc dynamic var definition: String = ""
    var examples = List<UnknownWordExample>()
}

class UnknownWordExample: Object, Codable {
    @objc dynamic var sentence: String = ""
    @objc dynamic var bookId: Int = 0
    @objc dynamic var index: Int = 0
}
