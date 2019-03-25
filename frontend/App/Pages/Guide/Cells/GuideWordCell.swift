//
//  GuideWordCell.swift
//  app
//
//  Created by sunho on 2019/03/25.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideWordCell: UITableViewCell {
    static let name = "wordCell"
    var container: PaddingMarginView!
    var titleView: UILabel!
    var numberView: UILabel!
    var button: RoundButton!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container = PaddingMarginView()
        container.padding.all = 20
        container.margin.top = 24
        container.layout()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.box.clipsToBounds = false
        container.box.backgroundColor = .white
        container.box.borderRadius = .normal
        container.box.shadowOffset = CGSize(width: 0, height: 0)
        container.box.shadowRadius = 14
        container.clipsToBounds = false
        
        titleView = UILabel()
        titleView.text = "오늘 복습해야할 단어수"
        container.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        titleView.setFont(.medium, .black, .medium)
        
        numberView = UILabel()
        numberView.text = "10"
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
        
        clipsToBounds = false
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.box.dropShadow(offset: CGSize(width: 2, height: -3), radius: 30)
    }
}
