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
    var valueView: UITextView!
    
    var value: Float = 0 {
        didSet {
            if value != oldValue {
                layoutSubviews()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        valueView = UITextView()
        valueView.makeStaticText()
        valueView.makeSmallText()
        valueView.textColor = UIUtill.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("inin(aDecoder")
    }
    
    var progressColor:UIColor = UIUtill.tint {
        didSet {
            progressLayer.fillColor = progressColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        progressLayer.removeFromSuperlayer()
        layout()
    }
    
    fileprivate func layout() {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width*0.85)/2, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(-0.5 * Float.pi + 2.0 * value * Float.pi), clockwise: true)
        circlePath.addLine(to: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0))
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = progressColor.cgColor
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
    
    func updateValueViewDefault() {
        valueView.text = "\(Int(value * 100))%"
    }
}
