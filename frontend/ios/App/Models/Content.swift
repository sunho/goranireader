//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

enum ContentType: Hashable {
    case epub
}

struct ContentKey: Hashable {
    var id: Int
    var type: ContentType
}

class Content {
    var id: Int
    var name: String
    var author: String
    var cover: Source?
    var updatedAt: Date
    var type: ContentType
    
    var key: ContentKey {
        return ContentKey(id: id, type: type)
    }
    
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
    
//    convenience init(epub: FRBook, id: Int, updatedAt: Date, path: String, progress: Float) {
//        let href = epub.coverImage?.fullHref
//        let turl = href != nil ? try? href!.asURL() : nil
//        let url = turl != nil ? URL(fileURLWithPath: turl!.path) : nil
//        let cover = url != nil ? Source.provider(LocalFileImageDataProvider(fileURL: url!)) : nil
//        self.init(id: id, name: epub.title ?? "", author: epub.authorName ?? "", cover: cover, updatedAt: updatedAt, type: .epub, path: path, progress: progress)
//    }
    
    func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
}

class DownloadableContent: Content {
    var downloadUrl: String
    
    init(id: Int, name: String, author: String, cover: Source?, updatedAt: Date, type: ContentType, downloadUrl: String) {
        self.downloadUrl = downloadUrl
        super.init(id: id, name: name, author: author, cover: cover, updatedAt: updatedAt, type: type)
    }
    
    convenience init(book: Book, type: ContentType, downloadUrl: String) {
        let coverUrl = URL(string: book.cover)
        let cover = coverUrl != nil ? Source.network(ImageResource(downloadURL: coverUrl!)) : nil
        self.init(id: book.id, name: book.name, author: book.author, cover: cover, updatedAt: book.updatedAt.iso8601!, type: type, downloadUrl: downloadUrl)
    }
}
