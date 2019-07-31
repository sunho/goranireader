//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

class ShadowView: UIView {
    var cornerRadius: CGFloat = 0 {
        didSet {
            setupShadow()
        }
    }
    
    var shadowRadius: CGFloat = 0 {
        didSet {
            setupShadow()
        }
    }
    
    var shadowOffset: CGSize = CGSize.zero {
        didSet {
            setupShadow()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        if self.shadowRadius == 0 {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        } else {
            self.layer.cornerRadius = cornerRadius
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
            self.layer.masksToBounds = false
        }
    }
}
