//
//  MemoryButton.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class MemoryButton: UIButton {
    var text: String? {
        didSet {
            setTitle(text, for: .normal)
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        borderRadius = .small
        setTitle("", for: .normal)
        setTitleColor(Color.strongGray, for: .normal)
        titleLabel!.numberOfLines = 0
        titleLabel!.lineBreakMode = .byWordWrapping
        titleLabel!.preferredMaxLayoutWidth = titleLabel?.frame.width ?? 0
        titleLabel!.setFont(.normal, Color.strongGray, .medium)
        updateState(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.preferredMaxLayoutWidth = titleLabel?.frame.width ?? 0
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let size = titleLabel?.intrinsicContentSize ?? CGSize.zero
            return CGSize(width: size.width + titleEdgeInsets.left + titleEdgeInsets.right, height: size.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        }
    }
    
    func updateLayout(_ detail: Bool) {
        if detail {
            titleEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        } else {
            titleEdgeInsets = UIEdgeInsets.zero
        }
    }
    
    func updateState(_ detail: Bool) {
        if detail {
            setTitleColor(Color.white, for: .normal)
            isUserInteractionEnabled = true
            backgroundColor = Color.tint
        } else {
            setTitleColor(Color.strongGray, for: .normal)
            isUserInteractionEnabled = false
            backgroundColor = .clear
        }
    }
}
