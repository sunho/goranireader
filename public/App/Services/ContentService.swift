//
//  ContentService.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import ReactiveSwift
import Kingfisher
import Moya
import Regex
import UIKit

fileprivate let epubPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\.epub", groupNames: "id", "timestamp")
fileprivate let sensPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\.sens", groupNames: "id", "timestamp")

fileprivate struct ContentKey: Hashable {
    var id: Int
    var type: ContentType
}

class ContentService {
    static let shared = ContentService()
    
    init() {
    }
    
    func getDownloadedContents() -> [Content] {
        return []
    }
    
    fileprivate func getLocalContents() -> Dictionary<ContentKey, String> {
        guard let paths = FileUtill.contentsOfDirectory(path: FileUtill.booksDir.path) else {
            assert(true)
            return [:]
        }

        var visit: Dictionary<ContentKey, Int> = [:]
        var out: Dictionary<ContentKey, String> = [:]
        for path in paths {
            let filename = (path as NSString).lastPathComponent
            let epubMatch = epubPattern.findFirst(in: filename)
            let sensMatch = sensPattern.findFirst(in: filename)
            if let match = epubMatch ?? sensMatch {
                guard let id = Int(match.group(named: "id") ?? "die") else {
                    continue
                }
                guard let timestamp = Int(match.group(named: "timestamp") ?? "die") else {
                    continue
                }
                let type: ContentType = epubMatch != nil ? .epub : .sens
                let key = ContentKey(id: id, type: type)
                if let current = visit[key] {
                    if timestamp < current {
                        continue
                    }
                }
                out[key] = path
                visit[key] = timestamp
            }
        }
        return out
    }
    
    func getDownloadableContents() -> SignalProducer<[Content], GoraniError> {
        let localContents = getLocalContents()
        return APIService.shared.request(.listBooks)
            .filterSuccessfulStatusCodes()
            .map([Book].self)
            .mapError { (error: MoyaError) -> GoraniError in
                return .network(error: error)
            }
            .map { (books: [Book]) -> [Content] in
                var out: [Content] = []
                for book in books {
                    if localContents[ContentKey(id: book.id, type: .sens)] == nil && book.sens != nil {
                        out.append(DownloadableContent(book: book, type: .sens, downloadUrl: book.sens!))
                    }
                    if localContents[ContentKey(id: book.id, type: .epub)] == nil && book.epub != nil {
                        out.append(DownloadableContent(book: book, type: .epub, downloadUrl: book.epub!))
                    }
                }
                return out
            }
    }
}
