//
//  AnswerListTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/20.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class AnswerListTableViewCell: UITableViewCell {
    fileprivate var container: PaddingMarginView!
    var indexView: UILabel!
    var textView: UILabel!
    override var isOpaque: Bool {
        didSet {
            container.isHidden = isOpaque
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        container = PaddingMarginView()
        container.padding.top = 12
        container.padding.bottom = 12
        container.margin.top = 8
        container.margin.bottom = 8
        container.layout()
        
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }

        indexView = UILabel()
        container.addSubview(indexView)
        indexView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        indexView.setFont()
        container.box.backgroundColor = UIUtill.gray
        container.box.borderRadius = .small
        
        textView = UILabel()
        container.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        textView.setFont()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        container.box.backgroundColor = highlighted ? UIUtill.gray.darker() : UIUtill.gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        container.box.backgroundColor = selected ? UIUtill.tint : UIUtill.gray
    }
}
