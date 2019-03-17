//
//  Content.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit
import FolioReaderKit
import Kingfisher

enum ContentType: Hashable {
    case epub
    case sens
}

class Content {
    var id: Int
    var name: String
    var author: String
    var cover: Source?
    var updatedAt: Date
    var type: ContentType
    
    init(id: Int, name: String, author: String, cover: Source?, updatedAt: Date, type: ContentType) {
        self.id = id
        self.name = name
        self.author = author
        self.cover = cover
        self.updatedAt = updatedAt
        self.type = type
    }
}

class DownloadedContent: Content {
    var path: String
    var progress: Float
    
    init(id: Int, name: String, author: String, cover: Source?, updatedAt: Date, type: ContentType, path: String, progress: Float) {
        self.path = path
        self.progress = progress
        super.init(id: id, name: name, author: author, cover: cover, updatedAt: updatedAt, type: type)
    }
}

class DownloadableContent: Content {
    var downloadUrl: String
    
    init(id: Int, name: String, author: String, cover: Source?, updatedAt: Date, type: ContentType, downloadUrl: String) {
        self.downloadUrl = downloadUrl
        super.init(id: id, name: name, author: author, cover: cover, updatedAt: updatedAt, type: type)
    }
    
    convenience init(book: Book, type: ContentType, downloadUrl: String) {
        self.init(id: book.id, name: book.name, author: book.author, cover: .network(ImageResource(downloadURL: URL(string: book.cover)!)), updatedAt: book.updatedAt.iso8601!, type: type, downloadUrl: downloadUrl)
    }
}
