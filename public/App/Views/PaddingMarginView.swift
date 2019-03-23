//
//  PaddingMarginView.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class PaddingMarginView: UIView {
    var box: UIView! // padding
    var inbox: UIView!
    fileprivate var marginBox: UIView!
    
    var margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    init() {
        super.init(frame: CGRect())
        marginBox = UIView()
        super.addSubview(marginBox)
        box = UIView()
        marginBox.addSubview(box)
        inbox = UIView()
        box.addSubview(inbox)
    }

    func layout() {
        marginBox.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(margin)
        }
        
        box.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        inbox.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(padding)
        }
    }
    
    override func addSubview(_ view: UIView) {
        inbox.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
