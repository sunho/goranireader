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

class GuideMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var providers: [GuideCardProvider] = []
    var cellIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.gray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.clipsToBounds = false
        tableView.backgroundColor = .clear
        
        providers = [GuideCardProvider(name: "wordCard", cellType: WordGuideCard.self, count: self.wordCardIdCount)]
        registerProviderCards()
        reload()
        
        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
    }
    
    func wordCardIdCount() -> Int {
        return RealmService.shared.getTodayUnknownWords().count > 0 ? 1 : 0
    }
    
    func registerProviderCards() {
        for provider in providers {
            tableView.register(provider.cellType, forCellReuseIdentifier: provider.name)
        }
    }
    
    func reload() {
        cellIds = providers.flatMap { p in
            return [String].init(repeating: p.name, count: p.count())
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = cellIds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: name)
        switch name {
        case "wordCard":
            let cell = cell as! WordGuideCard
            let remain = RealmService.shared.getTodayUnknownWords().count
            cell.numberView.text = "\(remain)"
            cell.button.addTarget(self, action: #selector(pushWordVC(_:)), for: .touchUpInside)
            return cell
        default:
            fatalError("?")
        }
    }
    
    @objc func pushWordVC(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordMainViewController") as! WordMainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIds.count
    }
    
    @objc func unknownWordAdded(notification: NSNotification) {
        reload()
    }
}
