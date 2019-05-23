//
//  GuideWordCardView.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideWordCardView: UIView {
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setImage(UIImage(named: "word_tab_icon")?.maskWithColor(color: .white), for: .normal)
        button.setImage(UIImage(named: "word_tab_icon")?.maskWithColor(color: Color.darkGray), for: .disabled)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
}
