import Foundation
import UIKit

class UIUtill {
    class var green: UIColor {
        return UIColor(rgba: "#FFE66D")
    }
    
    class var black: UIColor {
        return UIColor.black
    }
    
    class var white: UIColor {
        return UIColor.white
    }
    
    class var strongTint: UIColor {
        return UIColor(rgba: "#0B4F6C")
    }
    
    class var tint: UIColor {
        return UIColor(rgba: "#01BAEF")
    }
    
    class var gray: UIColor {
        return UIColor(rgba: "#999999")
    }
    
    class var lightGray1: UIColor {
        return UIColor(rgba: "#E3E3E2")
    }
    
    class var lightGray0: UIColor {
        return UIColor(rgba: "#F0F0F0")
    }
    
    class var blue: UIColor {
        return UIColor(rgba: "#006FFF")
    }
    
    class func roundView(_ view: UIView, _ radius: CGFloat = 10) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    class func dropShadow(_ view: UIView, offset: CGSize, radius: CGFloat, alpha: Float = 0.06) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = alpha
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
}

extension UITextView {
    func makeSmallText() {
        self.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    func makeBoldText() {
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func makeGrayText() {
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = UIUtill.gray
    }
}
