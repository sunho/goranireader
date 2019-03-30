//
//  RecommendMainViewController.swift
//  app
//
//  Created by sunho on 2019/02/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

struct GuideCardProvider {
    var name: String
    var cellType: AnyClass?
    var count: () -> Int
}

class GuideMainViewController: UIViewController {

    
    @IBOutlet weak var targetBookView: GuideTargetBookView!
    @IBOutlet weak var progressView: GuideProgressView!
    @IBOutlet weak var wordCardView: GuideWordCardView!
    @IBOutlet weak var bookView: GuideRecommendedBookView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
//        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
   }
}
