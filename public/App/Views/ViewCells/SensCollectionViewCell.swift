//
//  SensCollectionViewCell.swift
//  app
//
//  Created by sunho on 2019/03/19.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import SnapKit

class SensCollectionViewCell: UICollectionViewCell {
    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView = UITextView()
        textView.isEditable = false
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.bottom.top.left.right.equalToSuperview()
        }
        backgroundColor = UIUtill.gray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
