//
//  SocialMainShareCell.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class SocialMainPostCell: UITableViewCell {
    var sentenceView: UILabel!
    var usernameView: UILabel!
    var commentView: UILabel!
    var bottomView: SocialPostBottomView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        usernameView = UILabel()
        // TODO userinfo cache
        usernameView.text = "username"
        contentView.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        sentenceView = UILabel()
        contentView.addSubview(sentenceView)
        sentenceView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
        }
        
        bottomView = SocialPostBottomView()
        contentView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(sentenceView.snp.bottom)
             make.bottom.equalToSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
