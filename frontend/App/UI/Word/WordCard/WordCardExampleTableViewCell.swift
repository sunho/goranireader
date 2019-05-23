//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class WordCardExampleTableViewCell: UITableViewCell {
    var sentenceView: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        sentenceView = MultilineLabel()
        contentView.addSubview(sentenceView)
        sentenceView.snp.makeConstraints { make in
            make.right.bottom.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
        sentenceView.setFont(.normal, Color.strongGray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.sentenceView.preferredMaxLayoutWidth = self.sentenceView.frame.size.width
    }
}
