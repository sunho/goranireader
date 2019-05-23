//
//  Post.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct Post: Codable{
    var id: Int
    var userId: Int
    var createdAt: Date
    var updatedAt: Date
    var bookId: Int
    var topContent: String
    var sentence: String
    var bottomContent: String
    var solved: Bool
    var solvingContent: String?
    var solvingComment: Int?
    var rate: Int?
    var commentCount: Int?
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case bookId = "book_id"
        case topContent = "top_content"
        case sentence
        case bottomContent = "bottom_content"
        case solved
        case solvingContent = "solving_content"
        case solvingComment = "solving_comment"
        case rate
        case commentCount = "comment_count"
    }
}

struct Comment: Codable {
    var id: Int = 0
    var userId: Int = 0
    var postId: Int = 0
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var content: String = ""
    var rate: Int? = nil
    
    enum CodingKeys: String, CodingKey
    {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case postId = "post_id"
        case content
        case rate
    }
}
