//
//  BookyBook.swift
//  app
//
//  Created by Sunho Kim on 11/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct BookyBook: Codable {
    let meta: Metadata
    let chapters: [Chapter]

    static func fromPath(path: String) throws -> BookyBook  {
        guard let url = try? URL(fileURLWithPath: path) else {
            throw GoraniError.nilResult
        }
        let buf = try Data(contentsOf: url)
        let out = try JSONDecoder().decode(BookyBook.self, from: buf)
        return out
    }
}

struct Chapter: Codable {
    let id: String
    let items: [Sentence]
    let title: String
    let fileName: String
    let questions: [Question]?
}

struct Question: Codable {
    let type: String
    let id: String
    let sentence: String?
    let wordIndex: Int?
    let options: [String]
    let answer: Int
}

struct Sentence: Codable {
    let id: String
    let content: String
    let start: Bool
}

struct Metadata: Codable {
    let id: String
    let title: String
    let cover: String?
    let coverType: String?
    let author: String
}
