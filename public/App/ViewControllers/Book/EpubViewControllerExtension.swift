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
    
    
    @objc func removeDictView() {
        if let vc = dictVC {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            dictVC = nil
        }
    }
    
    func presentDictView(bookName: String, rect: CGRect, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        removeDictView()
        let vc = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
        vc.word = word
        vc.sentence = sentence
        vc.index = index
        self.folioReader.readerContainer?.view.addSubview(vc.view)
        vc.didMove(toParent: self.folioReader.readerContainer)
        vc.view.frame = CGRect(x: 20, y: rect.maxY, width: UIScreen.main.bounds.width - 40, height: 300)
        dictVC = vc
    }
    
    func hideDictView() {
        removeDictView()
    }
    
    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        self.updateKnownWords()
        
        self.currentHTML = htmlContent
        return htmlContent
    }
}
