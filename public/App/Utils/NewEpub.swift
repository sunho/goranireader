import Foundation
import UIKit
import FolioReaderKit

class NewEpub: Epub {
    let tempURL: ManagedEpubURL
    
    init(epub: URL) throws {
        let tempURL = ManagedEpubURL(epub: epub)
        guard tempURL.isNew() else {
            tempURL.keep = true
            throw ShareError.notNew
        }
        self.tempURL = tempURL
        
        super.init()
        self.book = try FREpubParser().readEpub(epubPath: epub.path, removeEpub: false, unzipPath: FileUtill.booksDir.path)
        try self.parse()
    }
}
