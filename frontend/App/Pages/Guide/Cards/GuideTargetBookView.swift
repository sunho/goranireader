//
//  GuideTargetBookView.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideTargetBookView: UIView {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var nativeNameView: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
