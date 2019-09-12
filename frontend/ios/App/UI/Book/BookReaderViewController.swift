//
//  BookReaderViewController.swift
//  app
//
//  Created by Sunho Kim on 12/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class BookReaderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var webView: WKWebView!
    var book: BookyBook!
    var timer: Timer!
    var isStart: Bool = false
    var isEnd: Bool = false
    var wordUnknowns: [PaginateWordUnknown] = []
    var sentenceUnknowns: [PaginateSentenceUnknown] = []
    var elapsedTime = 0
    var inited: Bool = false
    var loaded: Bool = false
    var readingChapter: String = ""  {
        didSet {
            if inited {
                loaded = false
                guard let chapter = currentChapter else {
                    return
                }
                start(chapter.items, readingSentence)
            }
        }
    }
    var readingSentence: String = "" {
        didSet {
            saveProgress()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProgress()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "reader")!
        webView.configuration.userContentController.add(self, name: "bridge")
        webView.customUserAgent = "ios"
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        self.webView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        swipeRight.delegate = self
        self.webView.addGestureRecognizer(swipeRight)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            if isStart && inited && loaded {
                prev()
            }
        }
        else if gesture.direction == .left {
            if isEnd && inited && loaded {
                next()
            }
        }
    }
    
    func prev() {
        guard let chapter = currentChapter else {
            return
        }
        let i = book.chapters.firstIndex(where: { $0.id == chapter.id })!
        if i > 0 {
            let chap = book.chapters[i - 1]
            readingSentence = book.chapters[i - 1].items[safe: chap.items.count - 1]?.id ?? ""
            readingChapter = book.chapters[i - 1].id
        }
    }
    
    func next() {
        guard let chapter = currentChapter else {
            return
        }
        let i = book.chapters.firstIndex(where: { $0.id == chapter.id })!
        if i < book.chapters.count {
            readingSentence = book.chapters[i + 1].items[safe: 0]?.id ?? ""
            readingChapter = book.chapters[i + 1].id
        }
    }
    
    func initForPage() {
        elapsedTime = 0
        isStart = false
        isEnd = false
        wordUnknowns = []
        sentenceUnknowns = []
    }
    
    var currentChapter: Chapter? {
        let out = book.chapters.first(where: { $0.id == readingChapter })
        if out == nil {
            return book.chapters[safe: 0]
        }
        return out
    }
    
    @objc func tick() {
        elapsedTime += 100
    }
    
    func loadProgress() {
        let progress = RealmService.shared.getBookProgress(book.meta.id)
        readingChapter = progress.readingChapter
        readingSentence = progress.readingSentence
    }
    
    func saveProgress() {
        RealmService.shared.write {
            let progress = RealmService.shared.getBookProgress(book.meta.id)
            progress.readingChapter = readingChapter
            progress.readingSentence = readingSentence
        }
    }
    
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
    }
    
    
    func start(_ sentences: [Sentence], _ readingSentenceId: String?) {
        let input1 = String(data: try! JSONEncoder().encode(sentences), encoding: .utf8)!
        let input2 = "'" + (readingSentenceId ?? "") + "'"
        webView.evaluateJavaScript("window.webapp.start(\(input1),\(input2));") { _, error in
            if error != nil {
                print(error)
                AlertService.shared.alertErrorMsg(error!.localizedDescription)
            }
        }
    }
}
