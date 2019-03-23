//
//  WordCardExampleTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class WordCardExampleTableViewCell: UITableViewCell {
    var sentenceView: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        sentenceView = UILabel()
        contentView.addSubview(sentenceView)
        sentenceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sentenceView.setFont()
    }
}
