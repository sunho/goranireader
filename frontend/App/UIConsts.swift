//
//  UIConsts.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class Color {
    class var red: UIColor {
        return UIColor(rgba: "#FF006E")
    }
    
    class var green: UIColor {
        return UIColor(rgba: "#0CCE6B")
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
            return 12
        case .normal:
            return 14
        case .medium:
            return 17
        case .big:
            return 34
        }
    }
}

enum BorderRadius {
    case none
    case tiny
    case small
    case normal
    case big
}

extension BorderRadius {
    var value: CGFloat {
        switch self {
        case .none:
            return 0
        case .tiny:
            return 6
        case .small:
            return 12
        case .normal:
            return 24
        case .big:
            return 36
        }
    }
}

