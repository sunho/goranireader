//
//  MemoryBulletPageManager.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import BLTNBoard

class SocialCommentBulletPageManager {
    fileprivate let page = SocialCommentBulletPage()
    fileprivate var manager: BLTNItemManager
    var callback: ((_ comment: String) -> Void)?
    
    init() {
        manager = BLTNItemManager(rootItem: page)
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
    }
    
    func show() {
        manager.showBulletin(in: UIApplication.shared)
    }
    
    func didCancel(_ item: BLTNItem) {
        manager.dismissBulletin()
    }
    
    func didAction(_ item: BLTNItem) {
        let page = item as! SocialCommentBulletPage
        let text = page.commentInput.text ?? ""
        callback?(text)
        manager.dismissBulletin()
    }
}
