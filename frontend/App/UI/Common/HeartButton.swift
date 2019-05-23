//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

class HeartButton: UIButton {
    var heart: Bool = false {
        didSet {
            if heart {
                self.setImage(UIImage(named: "heart_icon")?.maskWithColor(color: Color.tint), for: .normal)
            } else {
                self.setImage(UIImage(named: "heart_blank_icon")?.maskWithColor(color: Color.strongGray), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setImage(UIImage(named: "heart_blank_icon")?.maskWithColor(color: Color.strongGray), for: .normal)
    }
    
    convenience init() {
        self.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
