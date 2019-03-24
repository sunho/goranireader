//
//  ContentTypeIconView.swift
//  app
//
//  Created by sunho on 2019/03/25.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class ContentTypeIconView: UIImageView {
    init(type: ContentType, big: Bool = false) {
        let image = UIImage(named: type == .epub ? "epub_icon" : "sens_icon")
        super.init(image: image)
        if !big {
            snp.makeConstraints{ make -> Void in
                make.height.equalTo(15)
                make.width.equalTo(26)
            }
        } else {
            snp.makeConstraints{ make -> Void in
                make.height.equalTo(22.5)
                make.width.equalTo(52)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
