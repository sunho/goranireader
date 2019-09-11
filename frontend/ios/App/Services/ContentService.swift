//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import Kingfisher
import Regex
import UIKit
import Promises

// TODO move this to book controller

fileprivate let epubPattern = try! Regex(pattern:"([^-]+)\\-([0-9]+)\\-book", groupNames: "id", "timestamp")

class ContentService {
    static let shared = ContentService()
    
    init() {
    }
    
    func downloadContent(_ content: DownloadableContent) -> Promise<Void> {
        let file: String = {
            return "\(content.id)-\(Int(Date().timeIntervalSince1970))-book.book"
        }()
        
        let dest = FileUtil.downloadDir.appendingPathComponent(file)
        let src = URL(string: content.downloadUrl)!
        return Promise { fulfill, reject in
            URLSession.shared.downloadTask(with: src, completionHandler: { (location, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let location = location, error == nil
                    else {
                        reject(GoraniError.internalError)
                        return
                }
                do {
                    try FileManager.default.moveItem(at: location, to: dest)
                    fulfill(Void())
                } catch {
                    reject(error)
                }
            }).resume()
        }
    }
    
    func getContents() -> Promise<[Content]> {
        return getDownloadableContents().then { out in
            return Promise(out + self.getDownloadedContents())
        }
    }
    
    func getDownloadedContents() -> [Content] {
        let localContents = self.getLocalContents()
        var out: [Content] = []
        for (id, path) in localContents {
            let progress = RealmService.shared.getBookProgress(id)
            let book = try! BookyBook.fromPath(path: path)
            out.append(DownloadedContent(book: book, path: path, progress: progress.progress))
        }
        return out
    }
    
    fileprivate func getLocalContents() -> Dictionary<String, String> {
        guard let paths = FileUtil.contentsOfDirectory(path: FileUtil.downloadDir.path) else {
            assert(true)
            return [:]
        }

        var visit: Dictionary<String, Int> = [:]
        var out: Dictionary<String, String> = [:]
        for path in paths {
            let filename = (path as NSString).lastPathComponent
            print(filename)
            let epubMatch = epubPattern.findFirst(in: filename)
            if let match = epubMatch {
                guard let id = match.group(named: "id") else {
                    continue
                }
                guard let timestamp = Int(match.group(named: "timestamp") ?? "die") else {
                    continue
                }
                print(id)
                print(path)
                if let current = visit[id] {
                    if timestamp < current {
                        continue
                    }
                }
                out[id] = path
                visit[id] = timestamp
            }
        }
        return out
    }
    
    func getDownloadableContents() -> Promise<[Content]> {
        let localContents = getLocalContents()
        return FirebaseService.shared.getOwnedBooks().then { books in
            return Promise(books.map { DownloadableContent(book: $0) })
            }.then { books in
                print("books:", books)
                return Promise(books.filter { !localContents.keys.contains($0.id) })
            }
    }
}
