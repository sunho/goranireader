//
//  BookListTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

enum BookListTableType {
    case local
    case download
    case shop
}

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
    
    var type: ContentType = .epub {
        didSet {
           layout()
        }
    }
    
    var tableType: BookListTableType = .local {
        didSet {
            layout()
        }
    }
    
    var progress: Float = 0 {
        didSet {
            layout()
        }
    }
    
    fileprivate var typeView: UIImageView!
    fileprivate var coverView: UIImageView!
    fileprivate var nameView: UITextView!
    fileprivate var authorView: UITextView!
    fileprivate var downloadView: UIImageView!
    fileprivate var progressView: CircleBarView!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.snp.makeConstraints { make -> Void in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }
        
        coverView = UIImageView(image: UIImage(named: "book_placeholder")!)
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.width.equalTo(67)
            make.bottom.top.equalToSuperview()
        }
        
        progressView = CircleBarView(frame: CGRect())
        contentView.addSubview(progressView)
        progressView.snp.makeConstraints { make -> Void in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        nameView = UITextView()
        contentView.addSubview(nameView)
        nameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(8)
            make.top.equalToSuperview().offset(2)
        }
        nameView.makeBoldText()
        nameView.makeStaticText()
        
        authorView = UITextView()
        contentView.addSubview(authorView)
        authorView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(10)
            make.top.equalTo(nameView.snp.bottom).offset(2)
        }
        authorView.makeGrayText()
        authorView.makeStaticText()
        
        typeView = UIImageView(image: UIImage(named: "epub_icon"))
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints{ make -> Void in
            make.height.equalTo(15)
            make.width.equalTo(26)
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
        }
        
        downloadView = UIImageView(image: UIImage(named: "download_btn"))
        contentView.addSubview(downloadView)
        downloadView.snp.makeConstraints{ make -> Void in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        layout()
    }
    
    fileprivate func layout() {
        switch type {
        case .epub:
            typeView.image = UIImage(named: "epub_icon")
        case .sens:
            typeView.image = UIImage(named: "sens_icon")
        }
        
        switch tableType {
        case .download:
            if progress == 0 {
                downloadView.isHidden = false
                progressView.isHidden = true
            } else {
                downloadView.isHidden = true
                progressView.isHidden = false
                progressView.progressColor = UIUtill.gray
                progressView.value = progress
            }
        case .shop:
            downloadView.isHidden = false
            progressView.isHidden = false
        case .local:
            downloadView.isHidden = true
            progressView.isHidden = false
            progressView.progressColor = UIUtill.tint
            if progress == 0 {
                progressView.value = 0
                progressView.valueView.text = "열기"
            } else {
                progressView.value = progress
            }
        }
    }
    
    func setCover(with: Source?) {
        coverView.kf.setImage(with: with, placeholder: UIImage(named: "book_placeholder"))
    }
}
