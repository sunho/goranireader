//
//  SocialSharedDetailViewController.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class SocialDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var post: Post!
    var comments: [Comment] = []
    
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var topContentView: UILabel!
    @IBOutlet weak var sentenceView: UILabel!
    @IBOutlet weak var bottomContentView: UILabel!
    @IBOutlet weak var commentView: UITableView!
    override func viewDidLoad() {
        modalPresentationStyle = .overFullScreen
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
        APIService.shared.request(.getUser(userId: post.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
            if !offline {
                self.usernameView.text = user!.username
            }
        }
        topContentView.text = post.topContent
        sentenceView.text = post.sentence
        bottomContentView.text = post.bottomContent
        
        commentView.register(SocialCommentCell.self, forCellReuseIdentifier: "cell")
        commentView.rowHeight = UITableView.automaticDimension
        commentView.estimatedRowHeight = 160
        commentView.delegate = self
        commentView.dataSource = self
        
        reloadData()
    }
    
    func reloadData() {
        APIService.shared.request(.listComment(postId: post.id))
            .handle(ignoreError: true, type: [Comment].self) { offline, comments in
                if !offline {
                    self.comments = comments!
                    self.commentView.reloadData()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.comments[indexPath.row]
        let cell = self.commentView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialMainPostCell
        cell.commentView.text = item.content
        APIService.shared.request(.getUser(userId: item.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
            if !offline {
                cell.usernameView.text = user!.username
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
