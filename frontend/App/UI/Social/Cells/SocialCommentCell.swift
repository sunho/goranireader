//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

protocol SocialCommentCellDelegate {
    func didTapHeartButton(_ cell: SocialCommentCell, _ tag: Int)
    func socialCommentCell(_ cell: SocialCommentCell, didGiveHeart: Int) -> Bool
    func socialCommentCell(_ cell: SocialCommentCell, heartNumberFor: Int) -> Int
}

class SocialCommentCell: UITableViewCell {
    var usernameView: UILabel!
    var upButton: UIButton!
    var commentView: UILabel!
    var heartNumberView: UILabel!
    var heartButton: HeartButton!
    var delegate: SocialCommentCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let container = UIView()
        contentView.addSubview(container)
        container.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.width.equalTo(50)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().priority(1000)
        }
        
        heartButton = HeartButton()
        container.addSubview(heartButton)
        heartButton.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(heartButton.snp.width)
        }
        
        heartNumberView = UILabel()
        container.addSubview(heartNumberView)
        heartNumberView.text = "0"
        heartNumberView.snp.makeConstraints { make -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(heartButton.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        usernameView = UILabel()
        // TODO userinfo cache
        usernameView.text = "username"
        contentView.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(container.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        commentView = UILabel()
        contentView.addSubview(commentView)
        commentView.snp.makeConstraints { make -> Void in
            make.left.equalTo(container.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
            make.bottom.equalToSuperview().priority(750)
        }
        
        heartButton.addTarget(self, action: #selector(tapHeartButton), for: .touchUpInside)
    }
    
    @objc func tapHeartButton() {
        delegate.didTapHeartButton(self, self.tag)
    }
    
    func reloadData() {
        heartNumberView.text = "\(delegate.socialCommentCell(self, heartNumberFor: self.tag))"
        heartButton.heart = delegate.socialCommentCell(self, didGiveHeart: self.tag)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
