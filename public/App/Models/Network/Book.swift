//
//  Book.swift
//  app
//
//  Created by sunho on 2019/02/11.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

class Book: Decodable {
    let id: Int
    let name: String
    let img: String
    let epub: String
}
