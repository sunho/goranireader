//
//  SocialShareCommentCell.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class SocialCommentCell: UITableViewCell {
    var usernameView: UILabel!
    var voteView: UILabel!
    var upButton: UIButton!
    var commentView: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        usernameView = UILabel()
        commentView = UILabel()
        voteView = UILabel()
        // TODO userinfo cache
        usernameView.text = "username"
        contentView.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(commentView)
        commentView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
