//
//  UserData.swift
//  app
//
//  Created by Sunho Kim on 11/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Userdata: Codable {
    let userId: String
    let ownedBooks: [String]
    let bookCheck: Timestamp
    init() {
        userId = ""
        ownedBooks = []
        bookCheck = Timestamp()
    }
}
