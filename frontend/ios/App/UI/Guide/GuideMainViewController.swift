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
    @IBOutlet weak var wordCardView: GuideWordCardView!
    @IBOutlet weak var missionBookView: GuideMissionBookView!
    
    var wordCount: Int = 0
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func unknownWordAdded(notification: Notification) {
        reloadData()
    }
    
    @IBAction func wordCardOpen(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "WordMainViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func layout() {
        if wordCount == 0 {
            wordCardView.button.isEnabled = false
            wordCardView.textView.text = "복습해야 할 단어가 없습니다"
        } else {
            wordCardView.button.isEnabled = true
            wordCardView.textView.text = "총 \(wordCount)개의 단어를 복습해야 합니다"
        }
        if let book = missionBook, let mission = mission {
            missionBookView.nameView.text = book.title
            missionBookView.authorView.text = book.author
            missionBookView.dueView.text = mission.due.dateValue().description
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
