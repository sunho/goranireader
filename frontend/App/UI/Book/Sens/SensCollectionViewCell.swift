//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import SnapKit

class SensCollectionViewCell: UICollectionViewCell {
    var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView = UITextView()
        textView.isEditable = false
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.bottom.top.left.right.equalToSuperview()
        }
        backgroundColor = Color.gray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
