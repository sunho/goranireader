//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import Result
import Kingfisher
import Regex
import UIKit

// TODO move this to book controller

fileprivate let epubPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\-epub", groupNames: "id", "timestamp")
fileprivate let sensPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\.sens", groupNames: "id", "timestamp")

class ContentService {
    static let shared = ContentService()
    
    init() {
    }
    
    func downloadContent(_ content: DownloadableContent) {
        let file: String = {
            if content.type == .epub {
                return "\(content.id)-\(Int(Date().timeIntervalSince1970))-epub.epub"
            } else {
                return "\(content.id)-\(Int(Date().timeIntervalSince1970)).sens"
            }
        }()
        
        let url = FileUtil.downloadDir.appendingPathComponent(file)
    }
    
    func getContents() -> [Content] {
        return []
    }
    
    func getDownloadedContents() -> [Content] {
        let localContents = self.getLocalContents()
        var out: [Content] = []
        for (key, path) in localContents {
            let progress = RealmService.shared.getEpubProgress(key.id)
//            out.append(DownloadedContent(id: key.id, updatedAt: progress.updatedAt, path: path, progress: progress.progress))
        }
        return out
    }
    
    fileprivate func getLocalContents() -> Dictionary<ContentKey, String> {
        guard let paths = FileUtil.contentsOfDirectory(path: FileUtil.booksDir.path) else {
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
                let type: ContentType = .epub
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
    
    func getDownloadableContents() -> [Content] {
        let localContents = getLocalContents()
        return []
    }
}
