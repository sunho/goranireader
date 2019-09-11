//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class BookListTableViewCell: UITableViewCell {
    var name: String = "" {
        didSet {
            nameView.text = name
        }
    }
    
    var author: String = "" {
        didSet {
            authorView.text = author
        }
    }
    
    var types: [ContentType] = [.epub] {
        didSet {
            layout()
        }
    }

    var container: PaddingMarginView!
    var typeStackView: UIStackView!
    var coverView: UIImageView!
    
    // right constraint needed
    var nameView: UILabel!
    
    var authorView: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.masksToBounds = false
        clipsToBounds = false
        
        selectedBackgroundView?.backgroundColor = Color.gray
        
        let margin = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        container = PaddingMarginView()
        container.margin = margin
        container.layout()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        coverView = UIImageView(image: UIImage(named: "book_placeholder")!)
        container.addSubview(coverView)
        coverView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview()
            make.height.equalTo(bounds.width * 0.2 * 1.5)
            make.width.equalTo(bounds.width * 0.2)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(999)
        }
        
        nameView = MultilineLabel()
        container.addSubview(nameView)
        nameView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(12)
            make.top.equalToSuperview().offset(2)
        }
        nameView.setFont(.normal, Color.black, .medium)
        
        authorView = UILabel()
        container.addSubview(authorView)
        authorView.snp.makeConstraints { make -> Void in
            make.left.equalTo(coverView.snp.right).offset(12)
            make.top.equalTo(nameView.snp.bottom).offset(4)
        }
        authorView.setFont(.normal, Color.strongGray)
        
        typeStackView = UIStackView()
        container.addSubview(typeStackView)
        typeStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-1)
            make.bottom.equalToSuperview()
        }
        typeStackView.spacing = 4
        typeStackView.distribution = .equalSpacing
        typeStackView.alignment = .fill
    }
    
    func layout() {
        typeStackView.removeAllArrangedSubviews()
        for type in types {
            typeStackView.addArrangedSubview(ContentTypeIconView(type: type))
        }
        typeStackView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.nameView.preferredMaxLayoutWidth = self.nameView.frame.size.width
    }
    
    func setCover(with: Source?) {
        coverView.kf.setImage(with: with, placeholder: UIImage(named: "book_placeholder"))
    }
}
