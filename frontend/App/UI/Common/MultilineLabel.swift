//
// Copyright © 2019 Sunho Kim. All rights reserved.
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
