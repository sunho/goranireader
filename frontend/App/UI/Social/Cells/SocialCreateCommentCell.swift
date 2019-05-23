//
//  SocialShareCommentCell.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class SocialCreateCommentCell: UITableViewCell {
    var usernameView: UILabel!
    var commentInput: UITextField!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        usernameView = UILabel()
        commentInput = UITextField()
        usernameView.text = "답변이나 의견을 적어주세요"
        contentView.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(commentInput)
        commentInput.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
