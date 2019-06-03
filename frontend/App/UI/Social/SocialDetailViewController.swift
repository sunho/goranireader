//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

class SocialDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SocialPostBottomViewDelegate, SocialCommentCellDelegate {
    var post: Post!
    var comments: [Comment] = []
    // TODO remove or implement
    var creating: Bool = false
    var manager: SocialCommentBulletPageManager = SocialCommentBulletPageManager()
    
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var topContentView: UILabel!
    @IBOutlet weak var sentenceView: UILabel!
    @IBOutlet weak var bottomContentView: UILabel!
    @IBOutlet weak var commentView: UITableView!
    @IBOutlet weak var bottomSectionView: SocialPostBottomView!
    override func viewDidLoad() {
        modalPresentationStyle = .overFullScreen
        navigationController?.isNavigationBarHidden = false
        bottomSectionView.delegate = self
        navigationItem.largeTitleDisplayMode = .never
        APIService.shared.request(.getUser(userId: post.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
            if !offline {
                self.usernameView.text = user!.username
            }
        }
        topContentView.text = post.topContent
        sentenceView.text = post.sentence
        bottomContentView.text = post.bottomContent
        
        commentView.register(SocialCommentCell.self, forCellReuseIdentifier: "comment")
        commentView.register(SocialCreateCommentCell.self, forCellReuseIdentifier: "create")
        commentView.rowHeight = UITableView.automaticDimension
        commentView.estimatedRowHeight = 160
        commentView.delegate = self
        commentView.dataSource = self
        
        manager.callback = self.postComment
        
        reloadData()
    }
    
    func reloadData() {
        APIService.shared.request(.getRatePost(postId: post.id))
            .handle(ignoreError: true, type: Rate.self) { offline, rate in
                if !offline {
                    if rate!.rate == 1 {
                        self.bottomSectionView.heartButton.heart = true
                    } else {
                        self.bottomSectionView.heartButton.heart = false
                    }
                }
        }
        APIService.shared.request(.listComment(postId: post.id))
            .handle(ignoreError: true, type: [Comment].self) { offline, comments in
                if !offline {
                    self.comments = comments!
                    self.comments.sort(by: { $0.rate ?? 0 > $1.rate ?? 0 })
                    self.commentView.reloadData()
                }
        }
        bottomSectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != comments.count {
            let item = self.comments[indexPath.row]
            let cell = self.commentView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! SocialCommentCell
            cell.tag = indexPath.row
            cell.delegate = self
            cell.commentView.text = item.content
            cell.reloadData()
            APIService.shared.request(.getUser(userId: item.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
                if !offline {
                    cell.usernameView.text = user!.username
                }
            }
            APIService.shared.request(.getRateComment(postId: item.postId, commentId: item.id))
                .handle(ignoreError: true, type: Rate.self) { offline, rate in
                    if !offline {
                        if rate!.rate == 1 {
                            cell.heartButton.heart = true
                        } else {
                            cell.heartButton.heart = false
                        }
                    }
            }
            return cell
        } else {
            let cell = self.commentView.dequeueReusableCell(withIdentifier: "create", for: indexPath) as! SocialCreateCommentCell
            return cell
        }
    }
    
    
    func didTapHeartButton(_ cell: SocialCommentCell, _ tag: Int) {
        var rate = 0
        if cell.heartButton.heart {
            rate = 0
        } else {
            rate = 1
        }
        APIService.shared.request(.rateComment(postId: post.id, commentId: comments[tag].id, rate: rate)).handle(ignoreError: true) { _, _ in
            self.reloadData()
        }
    }
    
    func socialCommentCell(_ cell: SocialCommentCell, didGiveHeart tag: Int) -> Bool {
        return false
    }
    
    func socialCommentCell(_ cell: SocialCommentCell, heartNumberFor tag: Int) -> Int {
        return comments[tag].rate ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creating ? comments.count + 1: comments.count
    }
    
    func didTapHeartButton(_ view: SocialPostBottomView, _ tag: Int) {
        var rate = 0
        if view.heartButton.heart {
            rate = 0
        } else {
            rate = 1
        }
        APIService.shared.request(.ratePost(postId: post.id, rate: rate)).handle(ignoreError: true) { _, _ in
            self.reloadData()
        }
    }
    
    func didTapCommentButton(_ view: SocialPostBottomView, _ tag: Int) {
        manager.show()
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, didGiveHeart: Int) -> Bool {
        return false
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, heartNumberFor: Int) -> Int {
        return post.rate ?? 0
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, commentNumberFor: Int) -> Int {
        return post.commentCount ?? 0
    }
    
    func postComment(_ text: String) {
        var comment = Comment()
        comment.content = text
        APIService.shared.request(.createComment(postId: post.id,comment: comment)).handle(ignoreError: true) { _, _ in
            self.reloadData()
        }
    }
}
