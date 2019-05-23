//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

// TODO make common interface
// TODO why don't use callback why

import Foundation
import BLTNBoard

class MemoryBulletPageManager {
    fileprivate let page = MemoryBulletPage()
    fileprivate var manager: BLTNItemManager
    fileprivate var cloudVC: MemoryCloudViewController
    fileprivate var uword: UnknownWord?
    var callback: ((_ memory: String) -> Void)?
    
    init() {
        manager = BLTNItemManager(rootItem: page)
        cloudVC = MemoryCloudViewController()
        page.dismissalHandler = didDismiss
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
    }
    
    func prepare() {
    }

    func show(_ uword: UnknownWord, above: UIViewController) {
        manager.showBulletin(above: above, animated: true, completion: {
            self.uword = uword
            self.manager.withContentView { contentView in
                let frame = contentView.superview!.convert(contentView.frame, to: nil)
                let nframe = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: UIScreen.main.bounds.size.width, height: frame.origin.y - UIApplication.shared.statusBarFrame.size.height)
                self.showCloudVC(nframe, uword.word)
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
        let text = page.memoryInput.text ?? ""
        RealmService.shared.write {
            uword!.memory = text
        }
        APIService.shared.request(.updateMemory(word: uword!.word, sentence: text)).start { event in
            switch event {
            case .failed(let error):
                AlertService.shared.alertError(error)
            default:
                print(event)
            }
        }
        callback?(text)
        manager.dismissBulletin()
    }
}
