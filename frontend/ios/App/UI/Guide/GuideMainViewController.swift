//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import Promises

struct GuideCardProvider {
    var name: String
    var cellType: AnyClass?
    var count: () -> Int
}

class GuideMainViewController: UIViewController {
    @IBOutlet weak var missionBookView: GuideMissionBookView!
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var progressView: UILabel!
    
    var username: String = ""
    var wordCount: Int = 0
    var evCount: Int = 0
    var mission: Mission?
    var missionBook: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        wordCount = RealmService.shared.getTodayUnknownWords().count
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
    }
    
    func reloadData() {
        wordCount = RealmService.shared.getTodayUnknownWords().count
        evCount = RealmService.shared.getEventLogs().count
        FirebaseService.shared.getClass().then { clas -> Promise<Book?> in
            guard let mission = clas.mission else {
                self.mission = nil
                self.missionBook = nil
                self.layout()
                return Promise<Book?> { () -> Book? in
                    return nil
                }
            }
            self.mission = mission
            return FirebaseService.shared.getBook(mission.bookId ?? "").then { book -> Book? in
                return book
            }
        }.then { book in
            self.missionBook = book
            self.layout()
        }
        FirebaseService.shared.getUserDoc().then { doc in
            let username = doc.data()?[safe: "username"] as? String ?? ""
            self.username = username
            self.layout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func unknownWordAdded(notification: Notification) {
        reloadData()
    }
    
    func layout() {
        if evCount == 0 {
            progressView.text = "Your progress has been sent to your teacher."
        } else {
            progressView.text = "There are some progress (\(evCount)) that were not sent to your teacher. Please connect to the internet and reopen this app to send your progress."
        }
        usernameView.text = username
        if let book = missionBook, let mission = mission, Date() < mission.due.dateValue() {
            missionBookView.nameView.text = book.title
            missionBookView.authorView.text = book.author
            missionBookView.dueView.text = (mission.due.dateValue() - Date()).readableString()
            missionBookView.msgView.text = mission.message
            if let cover = missionBook!.cover {
            missionBookView.coverView.kf.setImage(with: cover.source, placeholder: UIImage(named: "book_placeholder"))
            }
        } else {
            missionBookView.nameView.text = "No mission :)"
            missionBookView.authorView.text = ""
            missionBookView.dueView.text = ""
            missionBookView.coverView.image = UIImage(named: "book_placeholder")!
            missionBookView.msgView.text = ""
        }
    }
}
