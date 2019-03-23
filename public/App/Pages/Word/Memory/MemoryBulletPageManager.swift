//
//  MemoryBulletPageManager.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import BLTNBoard

class MemoryBulletPageManager {
    fileprivate let page = MemoryBulletPage()
    fileprivate var manager: BLTNItemManager
    fileprivate var cloudVC: MemoryCloudViewController
    
    init() {
        manager = BLTNItemManager(rootItem: page)
        cloudVC = MemoryCloudViewController()
        page.dismissalHandler = didDismiss
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
    }
    
    func prepare() {
    }

    func show(above: UIViewController, word: String) {
        manager.showBulletin(above: above, animated: true, completion: {
            self.manager.withContentView { contentView in
                let frame = contentView.superview!.convert(contentView.frame, to: nil)
                let nframe = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: frame.origin.y - UIApplication.shared.statusBarFrame.size.height)
                self.showCloudVC(nframe, word)
            }
        })
    }
    
    fileprivate func showCloudVC(_ frame: CGRect, _ word: String) {
        if ReachabilityService.shared.reach.value {
            cloudVC.show(frame: frame, word: word)
        }
    }
    
    func didDismiss(_ item: BLTNItem) {
        cloudVC.hide()
    }
    
    func didCancel(_ item: BLTNItem) {
        manager.dismissBulletin()
    }
    
    func didAction(_ item: BLTNItem) {
        let page = item as! MemoryBulletPage
        manager.dismissBulletin()
    }
}
