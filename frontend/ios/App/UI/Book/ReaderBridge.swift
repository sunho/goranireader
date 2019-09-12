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
                    wordSelected(body["i"] as! Int, body["sid"] as! String)
                case "paginate":
                    paginate(body["sids"] as! [String])
                case "sentenceSelected":
                    sentenceSelected(body["sid"] as! String)
                case "readingSentenceChange":
                    readingSentenceChange(body["sid"] as! String)
                case "dictSearch":
                    dictSearch(body["word"] as! String)
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
        start(chapter.items, readingSentence)
    }
    
    func setLoading(_ load: Bool) {
        if inited {
            loaded = !load
            if !load {
                initForPage()
            }
        }
    }
    
    func atStart() {
        initForPage()
        isStart = true
    }
    
    func atMiddle() {
        initForPage()
        isStart = false
        isEnd = false
    }
    
    func atEnd() {
        initForPage()
        isEnd = true
    }
    
    func paginate(_ sids: [String]) {
        print("paginate")
    }
    
    func wordSelected(_ i: Int, _ sid: String) {
        print("wordSelected")
    }
    
    func sentenceSelected(_ sid: String) {
        print("sentenceSelected")
    }
    
    func readingSentenceChange(_ sid: String) {
        readingSentence = sid
    }
    
    func dictSearch(_ word: String) -> String {
        print("dictSearch")
        return ""
    }
    
    func addUnknownWord(sid: String, wordIndex: Int, word: String, def: String) {
        print("addUnknownWord")
    }
    
    func addUnknownSentence(_ sid: String) {
        print("addUnknownSentence")
    }
}
