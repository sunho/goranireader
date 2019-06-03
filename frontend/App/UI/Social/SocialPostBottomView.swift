//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

protocol SocialPostBottomViewDelegate {
    func didTapHeartButton(_ view: SocialPostBottomView, _ tag: Int)
    func didTapCommentButton(_ view: SocialPostBottomView, _ tag: Int)
    func socialPostBottomView(_ view: SocialPostBottomView, didGiveHeart: Int) -> Bool
    func socialPostBottomView(_ view: SocialPostBottomView, heartNumberFor: Int) -> Int
    func socialPostBottomView(_ view: SocialPostBottomView, commentNumberFor: Int) -> Int
}

class SocialPostBottomView: UIView {
    var delegate: SocialPostBottomViewDelegate!
    var heartButton: HeartButton!
    // TODO make this work
    var commentButton: UIButton!
    var heartNumberView: UILabel!
    var commentNumberView: UILabel!
    
    convenience init() {
        self.init(frame: CGRect())
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        let container = UIView()
        addSubview(container)
        container.snp.makeConstraints { make -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        heartButton = HeartButton()
        heartButton.heart = true
        container.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(heartButton.snp.width)
            make.centerY.equalToSuperview().offset(0.5)
            make.left.equalToSuperview().offset(-3)
        }
        
        heartNumberView = UILabel()
        heartNumberView.text = "0"
        container.addSubview(heartNumberView)
        heartNumberView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(heartButton.snp.right).offset(3)
        }
        
        commentNumberView = UILabel()
        commentNumberView.text = "0"
        container.addSubview(commentNumberView)
        commentNumberView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        commentButton = UIButton(type: .custom)
        commentButton.setImage(UIImage(named: "comment_icon")?.maskWithColor(color: Color.strongGray), for: .normal)
        container.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(commentButton.snp.width)
            make.centerY.equalToSuperview()
            make.right.equalTo(commentNumberView.snp.left).offset(-6)
        }
        
        heartButton.addTarget(self, action: #selector(addHeart), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layout()
    }
    
    @objc func addHeart() {
        delegate.didTapHeartButton(self, self.tag)
    }
    
    @objc func addComment() {
        delegate.didTapCommentButton(self, self.tag)
    }
    
    func reloadData() {
        heartNumberView.text = "\(delegate.socialPostBottomView(self, heartNumberFor: self.tag))"
        commentNumberView.text = "\(delegate.socialPostBottomView(self, commentNumberFor: self.tag))"
        heartButton.heart = delegate.socialPostBottomView(self, didGiveHeart: self.tag)
    }
}
