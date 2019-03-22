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
    var isDetail: Bool = false {
        didSet {
            if oldValue != isDetail {
                updateState()
            }
        }
    }
    
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
        updateState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.preferredMaxLayoutWidth = titleLabel?.frame.width ?? 0
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    fileprivate func updateState() {
        if !isDetail {
            isUserInteractionEnabled = false
        } else {
            isUserInteractionEnabled = true
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return titleLabel?.intrinsicContentSize ?? CGSize.zero
        }
    }
}
