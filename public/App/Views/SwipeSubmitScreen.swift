//
//  SwipeSubmitScreen.swift
//  app
//
//  Created by sunho on 2019/03/20.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

protocol SwipeSubmitScreenDelegate {
    func swipeSubmitted()
}

class SwipeSubmitScreen: UIView, UIGestureRecognizerDelegate {
    var recognizer: UIPanGestureRecognizer!
    var container: UIView!
    var background: UIView!
    var animator: UIViewPropertyAnimator!
    var delegate: SwipeSubmitScreenDelegate?
    var scrollView: UIScrollView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        recognizer.delegate = self
        isUserInteractionEnabled = false
        container = UIView()
        container.backgroundColor = UIUtill.tint
        addSubview(container)
        container.frame = bounds
        container.alpha = 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let progress = -recognizer.translation(in: container).x / 100
        switch recognizer.state {
        case .began:
            container.transform = CGAffineTransform(translationX: self.container.frame.width, y: 0)
            container.alpha = 0
        case .changed:
            if progress > 0 && progress < 1 {
                container.transform = CGAffineTransform(translationX: self.container.frame.width * (1-progress), y: 0)
                container.alpha = progress
            }
        case .ended:
            if progress > 0.4 {
                let dur = 0.3 * Double(1-progress);
                UIView.animateKeyframes(withDuration: 0.6 + dur, delay: 0, options: [.calculationModeCubic], animations: {
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: dur) {
                        self.container.transform = CGAffineTransform(translationX: 0, y: 0)
                        self.container.alpha = 1
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: dur + 0.2, relativeDuration: 0.4) {
                       self.container.alpha = 0
                    }
                }, completion: { _ in
                    self.delegate?.swipeSubmitted()
                })
            } else {
                UIView.animate(withDuration: 0.4 * Double(1-progress), delay: 0, options: .curveEaseOut, animations: {
                    self.container.transform = CGAffineTransform(translationX: self.container.frame.width, y: 0)
                    self.container.alpha = 0
                }, completion: nil)
            }
            
        default:
            ()
        }
    }
}
