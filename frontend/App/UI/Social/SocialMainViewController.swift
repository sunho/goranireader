//
//  SocialMainViewController.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class SocialMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SocialMainPostCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.delegate = self
        tableView.dataSource = self
        reloadData()
    }
    
    func reloadData() {
        APIService.shared.request(.listPosts)
            .handle(ignoreError: true, type: [Post].self) { offline, posts in
                if !offline {
                    self.posts = posts!
                    self.tableView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.posts[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "SocialDetailViewController") as! SocialDetailViewController
        vc.post = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.posts[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialMainPostCell
        cell.sentenceView.text = item.sentence
        APIService.shared.request(.getUser(userId: item.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
            if !offline {
                cell.usernameView.text = user!.username
            }
        }
        return cell
    }
}
