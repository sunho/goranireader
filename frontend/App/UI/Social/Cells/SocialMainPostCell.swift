//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

class SocialMainPostCell: UITableViewCell {
    var container: PaddingMarginView!
    var sentenceView: UILabel!
    var bookView: UILabel!
    var usernameView: UILabel!
    var commentView: UILabel!
    var bottomView: SocialPostBottomView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container = PaddingMarginView()
        container.padding.left = 16
        container.padding.right = 16
        container.padding.top = 8
        container.padding.bottom = 8
        container.layout()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        usernameView = UILabel()
        // TODO userinfo cache
        usernameView.text = "username"
        container.addSubview(usernameView)
        usernameView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        sentenceView = UILabel()
        container.addSubview(sentenceView)
        sentenceView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(usernameView.snp.bottom)
        }
        
        bookView = UILabel()
        bookView.text = "bookname"
        container.addSubview(bookView)
        bookView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(sentenceView.snp.bottom)
        }
        
        
        bottomView = SocialPostBottomView()
        container.addSubview(bottomView)
        bottomView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(bookView.snp.bottom)
             make.bottom.equalToSuperview()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
