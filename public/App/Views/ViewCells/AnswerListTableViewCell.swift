//
//  AnswerListTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/20.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class AnswerListTableViewCell: UITableViewCell {
    fileprivate var container: UIView!
    var indexView: UITextView!
    var textView: UITextView!
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
        container = UIView()
        contentView.addSubview(container)
        
        container.borderRadius = .small
        container.backgroundColor = UIUtill.gray
        container.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        indexView = UITextView()
        container.addSubview(indexView)
        indexView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        indexView.setFont()
        indexView.makeStaticText()
        
        textView = UITextView()
        container.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        textView.setFont()
        textView.makeStaticText()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        container.backgroundColor = highlighted ? UIUtill.gray.darker() : UIUtill.gray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        container.backgroundColor = selected ? UIUtill.tint : UIUtill.gray
    }
}
