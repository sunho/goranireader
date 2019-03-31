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
    
    func selectionChanged(bookName: String, point: CGPoint, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        print(word)
        if word == "" {
            dictVC.hide()
            if currentWord != "" {
                let payload = UnknownDefinitionPayload()
                payload.sentence = currentSentence
                payload.original = currentWord
                payload.type = "epub"
                EventLogService.shared.send(payload)
            }
        } else {
            currentWord = word
            currentSentence = sentence
            dictVC.show(point, UnknownDefinitionTuple(word, currentBookId!, sentence, index))
        }
    }
    
    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        self.updateKnownWords()
        
        self.currentHTML = htmlContent
        return htmlContent
    }
    
    func dictViewControllerDidSelect(_ dictViewController: DictViewController, _ tuple: UnknownDefinitionTuple, _ word: DictEntry, _ def: DictDefinition) {
        RealmService.shared.putUnknownWord(word, def, tuple)
        let payload = UnknownDefinitionPayload()
        payload.sentence = tuple.sentence
        payload.word = word.word
        payload.original = tuple.word
        payload.defId = Int(def.id)
        payload.type = "epub"
        EventLogService.shared.send(payload)
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
        let chapter = folioReader.readerCenter?.currentPageNumber ?? 0
        print("page:", pageNumber)
        if lastPage != pageNumber || lastChapter != chapter {
            let interval = NSDate().timeIntervalSince(lastTextUpdated)
            lastTextUpdated = Date()
            if interval > MinInterval && (lastChapter == chapter && pageNumber > lastPage || lastChapter != chapter && pageNumber == 1){
                let payload = FlipPagePayload()
                payload.bookId = currentBookId!
                payload.interval = interval
                payload.paragraph = currentText ?? ""
                payload.page = lastPage
                payload.chapter = chapter
                payload.type = "epub"
                EventLogService.shared.send(payload)
            }
            lastPage = pageNumber
            lastChapter = chapter
        }
    }
    
    func currentText(_ text: String) {
        if text != currentText {
            lastTextUpdated = Date()
            currentText = text
        }
    }
}
