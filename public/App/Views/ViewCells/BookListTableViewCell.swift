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
    
    fileprivate var container: UIView!
    fileprivate var typeView: UIImageView!
    fileprivate var coverView: UIImageView!
    fileprivate var nameView: UILabel!
    fileprivate var authorView: UILabel!
    fileprivate var downloadView: UIImageView!
    fileprivate var progressView: CircleBarView!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container = UIView()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.margins)
        }
        coverView = UIImageView(image: UIImage(named: "book_placeholder")!)
        container.addSubview(coverView)
        coverView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.height.equalTo(coverView.snp.width).multipliedBy(1.5)
            make.width.equalTo(bounds.width * 0.2)
            make.bottom.top.equalToSuperview()
        }
        
        progressView = CircleBarView(frame: CGRect())
        container.addSubview(progressView)
        progressView.snp.makeConstraints { make -> Void in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        nameView = UILabel()
        container.addSubview(nameView)
        nameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(8)
            make.top.equalToSuperview().offset(2)
        }
        nameView.setFont(.normal)
        
        authorView = UILabel()
        container.addSubview(authorView)
        authorView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(10)
            make.top.equalTo(nameView.snp.bottom).offset(2)
        }
        authorView.setFont(.small, UIUtill.gray)
        
        typeView = UIImageView(image: UIImage(named: "epub_icon"))
        container.addSubview(typeView)
        typeView.snp.makeConstraints{ make -> Void in
            make.height.equalTo(15)
            make.width.equalTo(26)
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
        }
        
        downloadView = UIImageView(image: UIImage(named: "download_btn"))
        container.addSubview(downloadView)
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
