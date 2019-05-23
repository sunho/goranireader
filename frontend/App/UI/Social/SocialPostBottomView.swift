//
//  SocialPostBottomSection.swift
//  app
//
//  Created by sunho on 23/05/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit


class SocialPostBottomView: UIView {
    var heartButton: HeartButton!
    // TODO make this work
    var commentButton: UIButton!
    var heartNumberView: UILabel!
    var commentNumberView: UILabel!
    
    convenience init() {
        self.init(frame: CGRect())
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        let container = UIView()
        addSubview(container)
        container.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        heartButton = HeartButton()
        heartButton.heart = true
        container.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(heartButton.snp.width)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        heartNumberView = UILabel()
        heartNumberView.text = "0"
        container.addSubview(heartNumberView)
        heartNumberView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(heartButton.snp.right)
        }
        
        commentNumberView = UILabel()
        commentNumberView.text = "0"
        container.addSubview(commentNumberView)
        commentNumberView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        commentButton = UIButton(type: .custom)
        commentButton.setImage(UIImage(named: "comment_icon")?.maskWithColor(color: Color.strongGray), for: .normal)
        container.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(commentButton.snp.width)
            make.centerY.equalToSuperview()
            make.right.equalTo(commentNumberView.snp.left)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layout()
    }
}
