//
//  MultilineLabel.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class MultilineLabel: UILabel {
    init() {
        super.init(frame: CGRect())
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        numberOfLines = 0
        preferredMaxLayoutWidth = frame.width
        lineBreakMode = .byWordWrapping
    }
}
