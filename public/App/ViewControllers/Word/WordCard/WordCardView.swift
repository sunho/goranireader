//
//  WordCardView.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class WordCardView: CardView {
    var frontView: UIView!
    var backView: WordCardBackView!
    var wordView: UILabel!
    var opened: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        frontView = UIView()
        contentView.addSubview(frontView)
        frontView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        frontView.clipsToBounds = true
        frontView.backgroundColor = Color.tint
        frontView.borderRadius = .small
        frontView.isHidden = false
        
        wordView = UILabel()
        wordView.setFont(.big, Color.white, .bold)
        frontView.addSubview(wordView)
        wordView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backView = WordCardBackView(frame: frame)
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
