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

class BookReaderViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    var book: BookyBook!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "reader")!
        webView.configuration.userContentController.add(self, name: "bridge")
        webView.customUserAgent = "ios"
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView,
                          didFinish navigation: WKNavigation!) {
        print("start")
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
