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
    var rateView: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentenceView = UILabel()
        usernameView = UILabel()
        // TODO userinfo cache
        usernameView.text = "username"
        contentView.addSubview(usernameView)
        contentView.addSubview(sentenceView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        sentenceView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
        }
        let container = UIView()
        contentView.addSubview(container)
        container.snp.makeConstraints { make -> Void in
            make.top.equalTo(sentenceView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
