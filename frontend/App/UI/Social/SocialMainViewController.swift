//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class SocialMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SocialPostBottomViewDelegate {
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
                    self.posts.sort(by: { $0.updatedAt > $1.updatedAt })
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
        cell.bottomView.tag = indexPath.row
        cell.bottomView.delegate = self
        cell.sentenceView.text = item.sentence
        cell.bottomView.reloadData()
        APIService.shared.request(.getUser(userId: item.userId)).mapPlain(User.self).handlePlain(ignoreError: true) { offline, user in
            if !offline {
                cell.usernameView.text = user!.username
            }
        }
        return cell
    }

    
    func didTapHeartButton(_ view: SocialPostBottomView, _ tag: Int) {
        var rate = 0
        if view.heartButton.heart {
            rate = 0
        } else {
            rate = 1
        }
        APIService.shared.request(.ratePost(postId: posts[tag].id, rate: rate)).handle(ignoreError: true) { _, _ in
            self.reloadData()
        }
    }
    
    func didTapCommentButton(_ view: SocialPostBottomView, _ tag: Int) {
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, didGiveHeart: Int) -> Bool {
        return false
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, heartNumberFor tag: Int) -> Int {
        return posts[tag].rate ?? 0
    }
    
    func socialPostBottomView(_ view: SocialPostBottomView, commentNumberFor tag: Int) -> Int {
        return posts[tag].commentCount ?? 0
    }
}
