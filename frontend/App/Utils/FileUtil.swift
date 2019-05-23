//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

fileprivate let fileManager = FileManager.default

// TODO make this into a service

class FileUtil {
    static let sharedDir: URL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.sunho.gorani-reader")!
    
    static let booksDir: URL = {
        let url = sharedDir.appendingPathComponent("books")
        if !fileManager.fileExists(atPath: url.path) {
           try! fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }()
    
    static let downloadDir: URL = {
        let url = sharedDir.appendingPathComponent("downloads")
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }()
    
    class func contentsOfDirectory(path: String) -> [String]? {
        guard let paths = try? fileManager.contentsOfDirectory(atPath: path) else { return nil}
        return paths.map { content in (path as NSString).appendingPathComponent(content)}
    }
}

