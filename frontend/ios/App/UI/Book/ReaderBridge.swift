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
                    print("helllo")
//                    addUnknownWord(sid: body["sid"] as! String, wordIndex: body["wordIndex"] as! Int, word: body["word"] as! String, def: body["def"] as! String)
                case "submitQuestion":
                    submitQuestion(body["qid"] as! String, body["option"] as! String, body["right"] as! Bool)
                case "setReadingQuestion":
                    setReadingQuestion(body["qid"] as! String)
                case "endQuiz":
                    endQuiz()
                default:
                    fatalError("Unknown type for bridgeHandler")
                }
            }
        }
    }
    
    func initComplete() {
        inited = true
        start()
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
        saveProgress()
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
    
    func submitQuestion(_ qid: String, _ option: String, _ right: Bool) {
        RealmService.shared.addEventLog(
            ELSubmitQuestionPayload(bookId: book.meta.id,
                chapterId: currentChapter!.id,
                questionId: qid,
                option: option,
                right: right,
                time: elapsedTime)
        )
    }
    
    func setReadingQuestion(_ qid: String) {
        initForPage()
        print(qid)
        readingQuestion = qid
        saveProgress()
    }
    
    func endQuiz() {
        solvedChapters.append(currentChapter!.id)
        saveProgress()
        next()
    }
    
    func startReader(_ sentences: [Sentence], _ readingSentenceId: String?) {
        let input1 = String(data: try! JSONEncoder().encode(sentences), encoding: .utf8)!
        let input2 = "'" + (readingSentenceId ?? "") + "'"
        webView.evaluateJavaScript("window.webapp.startReader(\(input1),\(input2));") { _, error in
            if error != nil {
                print(error)
                AlertService.shared.alertErrorMsg(error!.localizedDescription)
            }
        }
    }
    
    func startQuiz(_ questions: [Question], _ readingQuestionId: String?) {
        let input1 = String(data: try! JSONEncoder().encode(questions), encoding: .utf8)!
        let input2 = "'" + (readingQuestionId ?? "") + "'"
        webView.evaluateJavaScript("window.webapp.startQuiz(\(input1),\(input2));") { _, error in
            if error != nil {
                print(error)
                AlertService.shared.alertErrorMsg(error!.localizedDescription)
            }
        }
    }
    
    func resolveDict(_ res: String) {   webView.evaluateJavaScript("window.app.dictSearchResolve('\(res.replacingOccurrences(of: "'", with: "\\'"))');") { _, error in
        if error != nil {
            print(error)
            AlertService.shared.alertErrorMsg(error!.localizedDescription)
            }
        }
    }
}
