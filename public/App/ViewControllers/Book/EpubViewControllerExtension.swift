//
//  EpubViewControllerExtension.swift
//  app
//
//  Created by sunho on 2019/03/19.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import FolioReaderKit

extension BookMainViewController: FolioReaderDelegate, FolioReaderCenterDelegate {
    fileprivate func updateKnownWords() {
        guard let html = self.currentHTML else {
            return
        }
    }
    
    func folioReaderDidClose(_ folioReader: FolioReader) {
        self.currentHTML = nil
    }
    
    func presentDictView(bookName: String, point: CGPoint, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        dictVC.show(point, word: word, sentence: sentence, index: index, bookId: currentBookId!)
    }
    
    func hideDictView() {
        dictVC.hide()
    }
    
    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        self.updateKnownWords()
        
        self.currentHTML = htmlContent
        return htmlContent
    }
}
