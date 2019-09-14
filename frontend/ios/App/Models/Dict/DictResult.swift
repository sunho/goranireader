//
//  DictResult.swift
//  app
//
//  Created by Sunho Kim on 14/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct DictResult: Codable {
    let words: [DictEntry]
    let addable: Bool
}
