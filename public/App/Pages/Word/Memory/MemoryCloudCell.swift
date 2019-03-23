//
//  MemoryCloud.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

enum MemoryCloudType {
    case word
    case sentence
}

class MemoryCloudCell: UIView {
    var id: Int?
    var container: PaddingMarginView!
    var textView: UILabel!
    var closeButton: UIButton!
    var copyButton: UIButton!
    var type: MemoryCloudType!
    
    init(type: MemoryCloudType) {
        super.init(frame: CGRect())
        
        container = PaddingMarginView()
        container.padding.all = 8
        container.layout()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        container.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 60)
        }
        
        container.box.backgroundColor = Color.white
        container.box.borderRadius = .small
        
        self.type = type
        
        textView = MultilineLabel()
        container.addSubview(textView)
        textView.text = "..."
        textView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        textView.setFont(.normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
