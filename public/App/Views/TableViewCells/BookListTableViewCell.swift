//
//  BookListTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import SnapKit

class BookListTableViewCell: UITableViewCell {
    var name: String = "" {
        didSet {
            nameView.text = name
        }
    }
    
    var author: String = "" {
        didSet {
            authorView.text = author
        }
    }
    
    var coverView: UIImageView!
    var nameView: UITextView!
    var authorView: UITextView!
    var progressView: CircleBarView!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        coverView = UIImageView(image: UIImage(named: "book_placeholder")!)
        contentView.addSubview(coverView)
        coverView.contentMode = .scaleAspectFit
        coverView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        
        progressView = CircleBarView(frame: CGRect())
        contentView.addSubview(progressView)
        progressView.value = 0.5
        progressView.snp.makeConstraints { make -> Void in
            make.height.equalTo(35)
            make.width.equalTo(35)
            make.right.equalToSuperview().offset(-3)
            make.bottom.equalToSuperview().offset(-3)
        }
        
        nameView = UITextView()
        contentView.addSubview(nameView)
        nameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(5)
            make.top.equalToSuperview()
        }
        nameView.makeBoldText()
        nameView.makeStaticText()
        
        authorView = UITextView()
        contentView.addSubview(authorView)
        authorView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(5)
            make.top.equalTo(nameView.snp.bottom).offset(5)
        }
        authorView.makeGrayText()
        authorView.makeStaticText()
    }
    
    func setImage(image: UIImage) {
    }

}
