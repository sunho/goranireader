//https://github.com/saoudrizwan/CardSlider

import Foundation
import UIKit

public enum CardOption: String {
    case easy = "쉬움"
    case medium = "중간"
    
    case difficult = "어려움"
    case retry = "다시"
}

class CardView: UIView {
    var index: Int?
    var contentView: UIView!
    var greenLabel: CardViewLabel!
    var redLabel: CardViewLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // card style
        contentView = UIView()
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // labels on top left and right
        
        let padding: CGFloat = 20
        
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: UIColor(red: 102/255, green: 209/255, blue: 158/255, alpha: 1.0))
        greenLabel.isHidden = true
        self.addSubview(greenLabel)
        
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: UIColor(red: 236/255, green: 137/255, blue: 134/255, alpha: 1.0))
        redLabel.isHidden = true
        self.addSubview(redLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardOption) {
        if option == .easy || option == .medium  {
            
            greenLabel.text = option.rawValue
            
            // fade out redLabel
            if !redLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.redLabel.alpha = 0
                }, completion: { (_) in
                    self.redLabel.isHidden = true
                })
            }
            
            // fade in greenLabel
            if greenLabel.isHidden {
                greenLabel.alpha = 0
                greenLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.greenLabel.alpha = 1
                })
            }
            
        } else {
            
            redLabel.text = option.rawValue
            
            
            // fade out greenLabel
            if !greenLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.greenLabel.alpha = 0
                }, completion: { (_) in
                    self.greenLabel.isHidden = true
                })
            }
            
            // fade in redLabel
            if redLabel.isHidden {
                redLabel.alpha = 0
                redLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.redLabel.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // fade out greenLabel
        if !greenLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.greenLabel.alpha = 0
            }, completion: { (_) in
                self.greenLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        // fade out redLabel
        if !redLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.redLabel.alpha = 0
            }, completion: { (_) in
                self.redLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }
    
}

class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 60, height: 36)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setFont(.big, .white, .bold)
        self.textAlignment = .center
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }
    
    convenience init(origin: CGPoint, color: UIColor) {
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
