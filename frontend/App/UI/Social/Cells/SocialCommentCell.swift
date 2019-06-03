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
    var container2: PaddingMarginView!
    var usernameView: UILabel!
    var upButton: UIButton!
    var commentView: UILabel!
    var heartNumberView: UILabel!
    var heartButton: HeartButton!
    var delegate: SocialCommentCellDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container2 = PaddingMarginView()
        container2.padding.top = 8
        container2.padding.bottom = 8
        container2.layout()
        contentView.addSubview(container2)
        container2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let container = UIView()
        container2.addSubview(container)
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
        container2.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(container.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        commentView = UILabel()
        container2.addSubview(commentView)
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
