//
//  EpubViewControllerExtension.swift
//  app
//
//  Created by sunho on 2019/03/19.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import FolioReaderKit

let MinInterval: Double = 2

extension BookMainViewController: FolioReaderDelegate, FolioReaderCenterDelegate, DictViewControllerDelegate {
    fileprivate func updateKnownWords() {
        guard let html = self.currentHTML else {
            return
        }
    }
    
    func folioReaderDidAppear(_ folioReader: FolioReader) {
        dictVC.addViewToWindow()
        dictVC.delegate = self
    }
    
    func folioReaderDidClose(_ folioReader: FolioReader) {
        self.currentHTML = nil
        dictVC.removeViewFromWindow()
    }
    
    func pageDidLoad() {
        lastPage = folioReader.readerCenter!.webViewPage
        print(lastPage)
    }
    
    func presentDictView(bookName: String, point: CGPoint, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        dictVC.show(point, UnknownDefinitionTuple(word, currentBookId!, sentence, index))
    }
    
    func hideDictView() {
        dictVC.hide()
    }
    
    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        self.updateKnownWords()
        
        self.currentHTML = htmlContent
        return htmlContent
    }
    
    func dictViewControllerDidSelect(_ dictViewController: DictViewController, _ tuple: UnknownDefinitionTuple, _ word: DictEntry, _ def: DictDefinition) {
        RealmService.shared.putUnknownWord(word, def, tuple)
    }
    
    func saveLocation(_ location: Location?) {
        if let location = location {
            let pro = RealmService.shared.getEpubProgress(currentBookId!)
            RealmService.shared.write {
                pro.updatedAt = Date()
                pro.pageNumber = location.pageNumber
                pro.offsetX = location.offsetX
                pro.offsetY = location.offsetY
                pro.progress = location.progress
            }
        }
    }
    
    func loadLocation() -> Location? {
        let pro = RealmService.shared.getEpubProgress(currentBookId!)
        let out = Location()
        out.pageNumber = pro.pageNumber
        out.offsetX = pro.offsetX
        out.offsetY = pro.offsetY
        out.progress = pro.progress
        return out
    }
    
    func pageItemChanged(_ pageNumber: Int) {
        if lastPage != pageNumber {
            lastPage = pageNumber
            let interval = NSDate().timeIntervalSince(lastTextUpdated)
            if interval > MinInterval {
                let sentences = SentenceUtil.splitParagraph(currentText ?? "")
                let sizes = sentences.map { s in s.count }
                let payload = FlipPagePayload()
                payload.bookId = currentBookId!
                payload.interval = interval
                payload.sentences = sizes
                payload.type = "epub"
                EventLogService.shared.send(payload)
            }
        }
    }
    
    func currentText(_ text: String) {
        lastTextUpdated = Date()
        currentText = text
    }
}
