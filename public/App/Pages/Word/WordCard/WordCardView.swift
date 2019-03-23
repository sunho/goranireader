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
    var inset: UIEdgeInsets!
    
    //TODO: move to viewcontroller
    var isDetail: Bool = false {
        didSet {
            if oldValue != isDetail {
                self.updateLayout()
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.updateState()
                    self.layoutIfNeeded()
                    self.backView.updateTableView()
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = frame.size.width
        let height = frame.size.height
        let factorX: CGFloat = 0.67
        let factorY: CGFloat = 0.72

        inset = UIEdgeInsets(top: 0, left: (width - width * factorX) / 2, bottom: height - height * factorY, right: (width - width * factorX) / 2)
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
        
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
        
        updateState()
    }
    
    func updateLayout() {
        backView.updateLayout(isDetail)
        
        if isDetail {
            contentView.snp.updateConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            contentView.snp.updateConstraints { make in
                make.edges.equalToSuperview().inset(inset)
            }
        }
    }
    
    func updateState() {
        backView.updateState(isDetail)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
