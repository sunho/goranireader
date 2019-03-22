import Foundation
import UIKit

class UIUtill {
    class var red: UIColor {
        return UIColor(rgba: "#FF006E")
    }
    
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
        return UIColor(rgba: "#8338EC")
    }
    
    class var gray: UIColor {
        return UIColor(rgba: "#E8E9EB")
    }
    
    class var darkGray: UIColor {
        return UIColor(rgba: "#BEBFC1")
    }
    
    class var strongGray: UIColor {
        return UIColor(rgba: "#828283")
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

enum TextStroke {
    case normal
    case medium
    case bold
}

enum TextSize {
    case small
    case normal
    case medium
    case big
}

extension TextSize {
    var value: CGFloat {
        switch self {
        case .small:
            return 9
        case .normal:
            return 14
        case .medium:
            return 17
        case .big:
            return 20
        }
    }
}


enum BorderRadius {
    case none
    case small
    case normal
    case big
}

extension BorderRadius {
    var value: CGFloat {
        switch self {
        case .none:
            return 0
        case .small:
            return 12
        case .normal:
            return 24
        case .big:
            return 36
        }
    }
}


extension UILabel {
    func setFont(_ size: TextSize = .normal, _ color: UIColor = UIColor.black, _ stroke: TextStroke = .normal) {
        switch stroke {
        case .normal:
            self.font = UIFont.systemFont(ofSize: size.value)
        case .medium:
            self.font = UIFont.systemFont(ofSize: size.value, weight: .medium)
        case .bold:
            self.font = UIFont.boldSystemFont(ofSize: size.value)
        }
        self.textColor = color
    }
}


extension UIView {
    var borderRadius: BorderRadius {
        set {
            self.layer.cornerRadius = newValue.value
            self.clipsToBounds = true
        }
        
        get {
            return .none
        }
    }
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
