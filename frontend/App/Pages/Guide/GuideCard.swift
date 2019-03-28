//
//  GuideWordCell.swift
//  app
//
//  Created by sunho on 2019/03/25.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideCard: UITableViewCell {
    var container: PaddingMarginView!
    
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
        
        clipsToBounds = false
        backgroundColor = .clear
    }
}
