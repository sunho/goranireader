//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class GuideCard: UITableViewCell {
    var container: PaddingMarginView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container = PaddingMarginView()
        container.padding.all = 20
        container.margin.top = 24
        container.layout()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.box.clipsToBounds = false
        container.box.backgroundColor = .white
        container.box.borderRadius = .small
        container.box.shadowOffset = CGSize(width: 0, height: 5)
        container.box.shadowRadius = 8
        container.clipsToBounds = false
        
        clipsToBounds = false
        backgroundColor = .clear
    }
}
