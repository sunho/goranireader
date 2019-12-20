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
import RealmSwift

class BookReaderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate, BookGotoDelegate {
    @IBOutlet weak var webView: WKWebView!
    let sessionHandler = SessionHandler()
    var book: BookyBook!
    var timer: Timer!
    var isStart: Bool = false
    var isEnd: Bool = false
    var wordUnknowns: [PaginateWordUnknown] = []
    var sentenceUnknowns: [PaginateSentenceUnknown] = []
    var elapsedTime = 0
    var inited: Bool = false
    var loaded: Bool = false
    var readingChapter: String = ""
    var quiz: Bool = false
    var solvedChapters: [String] = []
    var readingQuestion: String = ""
    var readingSentence: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProgress()
        print("quiz:", quiz)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "reader")!
        webView.configuration.userContentController.add(self, name: "bridge")
        webView.customUserAgent = "ios"
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        self.webView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        swipeRight.delegate = self
        self.webView.addGestureRecognizer(swipeRight)
        
        navigationItem.title = book.meta.title
    }
    
    func start() {
        loaded = false
        guard let chapter = currentChapter else {
            fatalError("no chapter to start")
        }
        if !quiz {
            startReader(chapter.items, readingSentence)
            return
        }
        guard let questions = chapter.questions else {
            quiz = false
            saveProgress()
            fatalError("no questions")
        }
        startQuiz(questions, readingQuestion)
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
            quiz = false
            readingSentence = book.chapters[i - 1].items[safe: chap.items.count - 1]?.id ?? ""
            readingChapter = book.chapters[i - 1].id
            start()
        }
    }
    
    func next() {
        guard let chapter = currentChapter else {
            return
        }
        
        if let questions = chapter.questions
            ,questions.count != 0
            ,!solvedChapters.contains(chapter.id) {
            quiz = true
            readingSentence = ""
            readingQuestion = questions[0].id
            saveProgress()
            start()
        } else {
            let i = book.chapters.firstIndex(where: { $0.id == chapter.id })!
            if quiz && i == book.chapters.count - 1 {
                quiz = false
                readingSentence = book.chapters[i].items[safe: book.chapters[i].items.count - 1]?.id ?? ""
                readingQuestion = ""
                readingChapter = book.chapters[i].id
                saveProgress()
                start()
            } else if i + 1 < book.chapters.count {
                quiz = false
                readingSentence = book.chapters[i + 1].items[safe: 0]?.id ?? ""
                readingQuestion = ""
                readingChapter = book.chapters[i + 1].id
                saveProgress()
                start()
            }
        }
    }
    
    func initForChapter() {
        initForPage()
        isStart = false
        isEnd = false
    }
    
    func initForPage() {
        elapsedTime = 0
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
        readingQuestion = progress.readingQuestion
        quiz = progress.quiz
        solvedChapters = Array(progress.solvedChapers)
    }
    
    func saveProgress() {
        print(quiz)
        RealmService.shared.write {
            let progress = RealmService.shared.getBookProgress(book.meta.id)
            progress.readingChapter = readingChapter
            progress.readingSentence = readingSentence
            progress.readingQuestion = readingQuestion
            progress.quiz = quiz
            progress.solvedChapers.removeAll()
            progress.solvedChapers.append(objectsIn: solvedChapters)
        }
    }
    
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
    }
    
    func gotoResolve(_ chapter: Chapter) {
        readingChapter = chapter.id
        readingSentence = ""
        readingQuestion = ""
        quiz = false
        saveProgress()
        start()
    }
    
    @IBAction func goto(_ sender: Any) {
        if inited && loaded && !quiz {
            let vc = storyboard!.instantiateViewController(withIdentifier: "BookGotoTableViewController") as! BookGotoTableViewController
            vc.delegate = self
            vc.chapters = book.chapters
            vc.currentChapter = readingChapter
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sessionHandler.openSession()
        view.layoutIfNeeded()
    }
}
