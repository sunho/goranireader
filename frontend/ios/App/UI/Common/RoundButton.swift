//
// Copyright © 2019 Sunho Kim. All rights reserved.
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


