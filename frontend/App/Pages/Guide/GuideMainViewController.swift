//
//  RecommendMainViewController.swift
//  app
//
//  Created by sunho on 2019/02/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.gray
        tableView.register(GuideWordCell.self, forCellReuseIdentifier: GuideWordCell.name)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.clipsToBounds = false
        tableView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GuideWordCell.name) as! GuideWordCell
        cell.button.addTarget(self, action: #selector(pushWordVC(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func pushWordVC(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WordMainViewController") as! WordMainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
