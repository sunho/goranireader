//
//  CircleBarView.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class CircleBarView: UIView {
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var valueView: UITextView!
    
    var value: Float = 0 {
        didSet {
            valueView.text = "\(Int(value * 100))%"
            layoutIfNeeded()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        valueView = UITextView()
        self.addSubview(valueView)
        valueView.snp.makeConstraints { make -> Void in
            make.center.equalToSuperview()
        }
        valueView.makeStaticText()
        valueView.makeSmallText()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("inin(aDecoder")
    }
    
    var progressColor:UIColor = UIUtill.tint {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        print("hoi")
        progressLayer.removeFromSuperlayer()
        layout()
    }
    
    fileprivate func layout() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 1.5
        progressLayer.strokeEnd = CGFloat(value)
        layer.addSublayer(progressLayer)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateCircle")
    }
}
