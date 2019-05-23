//
// Copyright © 2019 Sunho Kim. All rights reserved.
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
