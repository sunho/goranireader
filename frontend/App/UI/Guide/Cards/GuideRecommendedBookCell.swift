//
//  GuideRecommendedBookCell.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class GuideRecomendedBookCell: UICollectionViewCell {
    var coverView: UIImageView!
    var closeButton: UIButton!
    var heartButton: HeartButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        coverView = UIImageView()
        addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(coverView.snp.width).multipliedBy(1.5)
        }

        let container = UIView()
        addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        heartButton = HeartButton()
        heartButton.heart = true
        container.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.36)
            make.height.equalTo(self.snp.width)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(2)
        }
        
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close_icon")?.maskWithColor(color: Color.strongGray), for: .normal)
        container.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.36)
            make.height.equalTo(closeButton.snp.width)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-2)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
