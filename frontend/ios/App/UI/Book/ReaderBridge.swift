//
//  ReaderBridge.swift
//  app
//
//  Created by Sunho Kim on 12/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import WebKit

extension BookReaderViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "bridge" {
            if let body = message.body as? [String: Any], let type = body["type"] as? String {
                switch type {
                case "initComplete":
                    initComplete()
                case "setLoading":
                    setLoading(body["load"] as! Bool)
                case "atStart":
                    atStart()
                case "atEnd":
                    atEnd()
                case "atMiddle":
                    atMiddle()
                case "wordSelected":
                    wordSelected(body["word"] as! String, body["i"] as! Int, body["sid"] as! String)
                case "paginate":
                    paginate(body["sids"] as! [String])
                case "sentenceSelected":
                    sentenceSelected(body["sid"] as! String)
                case "readingSentenceChange":
                    readingSentenceChange(body["sid"] as! String)
                case "dictSearch":
                    let out = dictSearch(body["word"] as! String)
                    resolveDict(out)
                case "addUnknownSentence":
                    addUnknownSentence(body["sid"] as! String)
                case "addUnknownWord":
                    addUnknownWord(sid: body["sid"] as! String, wordIndex: body["wordIndex"] as! Int, word: body["word"] as! String, def: body["def"] as! String)
                default:
                    fatalError("Unknown type for bridgeHandler")
                }
            }
        }
    }
    
    func initComplete() {
        inited = true
        guard let chapter = currentChapter else {
            return
        }
        startReader(chapter.items, readingSentence)
    }
    
    func setLoading(_ load: Bool) {
        if inited {
            loaded = !load
            if !load {
                initForChapter()
            }
        }
    }
    
    func atStart() {
        isStart = true
    }
    
    func atMiddle() {
        guard let chapter = currentChapter else {
            return
        }
        if chapter.items.count == 0 {
            return
        }
        isStart = false
        isEnd = false
    }
    
    func atEnd() {
        isEnd = true
    }
    
    func paginate(_ sids: [String]) {
        RealmService.shared.addEventLog(ELPaginatePayload(bookId: book.meta.id, chapterId: currentChapter!.id, time: elapsedTime, sids: sids, wordUnknowns: wordUnknowns, sentenceUnknowns: sentenceUnknowns))
    }
    
    func wordSelected(_ word: String, _ i: Int, _ sid: String) {
        wordUnknowns.append(PaginateWordUnknown(sentenceId: sid, word: word, wordIndex: i, time: elapsedTime))
    }
    
    func sentenceSelected(_ sid: String) {
        
    }
    
    func readingSentenceChange(_ sid: String) {
        initForPage()
        readingSentence = sid
    }
    
    func dictSearch(_ word: String) -> String {
        let words = DictService.shared.search(word: word)
        let out = DictResult(words: words, addable: false)
        guard let data = try? JSONEncoder().encode(out) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func addUnknownWord(sid: String, wordIndex: Int, word: String, def: String) {
        print("addUnknownWord")
    }
    
    func addUnknownSentence(_ sid: String) {
        sentenceUnknowns.append(PaginateSentenceUnknown(sentenceId: sid, time: elapsedTime))
        RealmService.shared.addEventLog(ELUnknownSentencePayload(bookId: book.meta.id, chapterId: currentChapter!.id, sentenceId: sid))
        AlertService.shared.alertSuccessMsg("Sentence was marked as unknown")
    }
}
