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
    
    var coverView: UIImageView!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        coverView = UIImageView(image: UIImage(named: "book_placeholder")!)
        coverView.contentMode = .scaleAspectFit
        addSubview(coverView)
        coverView.snp.makeConstraints { (make) -> Void in
            make.height.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func setImage(image: UIImage) {
    }

}
