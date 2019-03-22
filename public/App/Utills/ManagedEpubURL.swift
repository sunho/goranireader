import Foundation

class ManagedEpubURL {
    let contentURL: URL
    
    var keep: Bool = false
    var path: String {
        return contentURL.path
    }

    init(epub: URL) {
        self.contentURL = FileUtill.booksDir.appendingPathComponent(epub.lastPathComponent)
    }
    
    func isNew() -> Bool {
        return !FileManager.default.fileExists(atPath: self.contentURL.path)
    }
    
    deinit {
        if !self.keep {
            DispatchQueue.global(qos: .utility).async { [contentURL = self.contentURL] in
                try? FileManager.default.removeItem(at: contentURL)
            }
        }
    }
}
