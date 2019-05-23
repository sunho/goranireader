//https://github.com/saoudrizwan/CardSlider

import Foundation
import UIKit

fileprivate let factorX: CGFloat = 0.67 // TODO

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
        
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: Color.green)
        greenLabel.isHidden = true
        contentView.addSubview(greenLabel)
        
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width * factorX - CardViewLabel.size.width - padding, y: padding), color: Color.red)
        redLabel.isHidden = true
        contentView.addSubview(redLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardAnswerQuality) {
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
    fileprivate static let size = CGSize(width: 70, height: 36)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setFont(.medium, .white, .medium)
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
