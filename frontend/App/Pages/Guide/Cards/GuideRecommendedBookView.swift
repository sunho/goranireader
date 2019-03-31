//
//  GuideRecommendedBookView.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class GuideRecommendedBookView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 90, height: 180)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView.collectionViewLayout = flowLayout
    }
}
