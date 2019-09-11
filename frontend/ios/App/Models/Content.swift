//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

enum ContentType: Hashable {
    case epub
}

class Content {
    var id: String
    var name: String
    var author: String
    var cover: Source?
    
    init(id: String, name: String, author: String, cover: Source?) {
        self.id = id
        self.name = name
        self.author = author
        self.cover = cover
    }
}

class DownloadedContent: Content {
    var path: String
    var progress: Float
    
    init(id: String, name: String, author: String, cover: Source?, path: String, progress: Float) {
        self.path = path
        self.progress = progress
        super.init(id: id, name: name, author: author, cover: cover)
    }
    
    convenience init(book: BookyBook, path: String, progress: Float) {
        let cover = book.meta.cover != nil ? Source.provider(Base64ImageDataProvider(base64String: book.meta.cover!, cacheKey: path)) : nil
        self.init(id: book.meta.id, name: book.meta.title, author: book.meta.author, cover: cover, path: path, progress: progress)
    }
    
    func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
}

class DownloadableContent: Content {
    var downloadUrl: String
    
    init(id: String, name: String, author: String, cover: Source?, downloadUrl: String) {
        self.downloadUrl = downloadUrl
        super.init(id: id, name: name, author: author, cover: cover)
    }
    
    convenience init(book: Book) {
        let coverUrl = URL(string: book.cover ?? "")
        let cover = coverUrl != nil ? Source.network(ImageResource(downloadURL: coverUrl!)) : nil
        self.init(id: book.id, name: book.title, author: book.author, cover: cover, downloadUrl: book.downloadLink)
    }
}
