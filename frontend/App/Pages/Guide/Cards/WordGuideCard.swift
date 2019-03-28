//
//  WordGuideCard.swift
//  app
//
//  Created by sunho on 2019/03/28.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class WordGuideCard: GuideCard {
    var titleView: UILabel!
    var numberView: UILabel!
    var button: RoundButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleView = UILabel()
        titleView.text = "오늘 복습해야할 단어수"
        container.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        titleView.setFont(.medium, .black, .medium)
        
        numberView = UILabel()
        numberView.text = "0"
        container.addSubview(numberView)
        numberView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.left.equalToSuperview()
        }
        numberView.setFont(.big, .black, .medium)
        
        button = RoundButton()
        button.setTitle("단어 복습하기", for: .normal)
        button.backgroundColor = Color.tint
        button.setImage(UIImage(named: "word_tab_icon")?.maskWithColor(color: .white), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.setTitleColor(.white, for: .normal)
        container.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(numberView.snp.bottom).offset(30)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}

