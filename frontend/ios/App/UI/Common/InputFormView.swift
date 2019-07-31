//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class InputFormView: UIView {
    var views: [UIView]!
    
    init(views: [UIView]) {
        super.init(frame: CGRect())
        self.views = views
        let inset = UIEdgeInsets(top: 0, left: 12, bottom: 40, right: 12)
        let space = 20
        for (i, view) in views.enumerated() {
            addSubview(view)
            if i == 0 {
                view.snp.makeConstraints { make in
                    make.left.right.top.equalToSuperview().inset(inset)
                }
            } else if i == views.count - 1 {
                view.snp.makeConstraints { make in
                    make.top.equalTo(views[i-1].snp.bottom).offset(space)
                    make.left.right.equalToSuperview().inset(inset)
                    make.bottom.equalToSuperview().inset(inset)
                }
            } else {
                view.snp.makeConstraints { make in
                    make.top.equalTo(views[i-1].snp.bottom).offset(space)
                    make.left.right.equalToSuperview().inset(inset)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
