//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import Moya

struct GuideCardProvider {
    var name: String
    var cellType: AnyClass?
    var count: () -> Int
}

class GuideMainViewController: UIViewController {
    @IBOutlet weak var progressView: GuideProgressView!
    @IBOutlet weak var wordCardView: GuideWordCardView!
    
    var wordCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        wordCount = RealmService.shared.getTodayUnknownWords().count
        ReachabilityService.shared.reach.producer.start { [weak self] _ in
            self?.reloadData()
        }
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
    }
    
    func reloadData() {
        APIService.shared.request(.getMissions)
            .handle(ignoreError: true, type: [Mission].self) { offline, missions in
            if !offline {
                for mission in missions! {
                    print(mission)
                }
            }
        }
        wordCount = RealmService.shared.getTodayUnknownWords().count
        layout()
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
    }
}
