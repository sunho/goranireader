//
//  RoundButton.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    func layout() {
        borderRadius = .small
        setBackgroundImage(UIImage.imageWithColor(tintColor: Color.tint), for: .normal)
        setBackgroundImage(UIImage.imageWithColor(tintColor: Color.gray), for: .disabled)
        setTitleColor(Color.white, for: .normal)
        setTitleColor(Color.darkGray, for: .disabled)
    }
}
