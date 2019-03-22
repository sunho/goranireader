//
//  LineTextView.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class LineTextField: UITextField {
    var bottomLine: CALayer!
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    init() {
        super.init(frame: CGRect())
        layout()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    func layout() {
        snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        bottomLine = CALayer()
        layer.addSublayer(bottomLine)
        borderStyle = UITextField.BorderStyle.none
        font = UIFont.systemFont(ofSize: 15)
        placeHolderColor = Color.strongGray
        textColor = Color.black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = Color.darkGray.cgColor
    }    
}
