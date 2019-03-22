//
//  LineInputField.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class LineInputField: UIView {
    fileprivate var nameView: UILabel!
    var placeholder: String? {
        didSet {
            nameView.text = placeholder
        }
    }
    var textField: LineTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameView = UILabel()
        addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        nameView.setFont(.medium, UIUtill.strongGray, .medium)
        
        textField = LineTextField()
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        textField.placeholder = "입력"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
