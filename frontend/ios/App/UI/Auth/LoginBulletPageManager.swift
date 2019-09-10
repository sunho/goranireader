//
//  LoginBulletPageManager.swift
//  app
//
//  Created by Sunho Kim on 10/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import BLTNBoard

class LoginBulletPageManager: NSObject, UITextFieldDelegate {
    fileprivate var page: LoginBulletPage!
    fileprivate var manager: BLTNItemManager!
    var callback: (() -> Void)? = nil
    
    override init() {
        super.init()
        page = LoginBulletPage(self)
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
        manager = BLTNItemManager(rootItem: page)
    }
    
    func show(above: UIViewController) {
        manager.showBulletin(above: above)
    }
    
    func didCancel(_ item: BLTNItem) {
        manager.dismissBulletin()
    }
    
    func didAction(_ item: BLTNItem) {
        let page = item as! LoginBulletPage
        let word1 = page.word1Input.textField.text ?? ""
        let word2 = page.word2Input.textField.text ?? ""
        let number = page.numberInput.textField.text ?? ""
        FirebaseService.shared.login(word: word1, word2: word2, number: number) { success, replacing, error in
            if error != nil {
                AlertService.shared.alertErrorMsg(error!.localizedDescription)
                return
            }
            if !success {
                AlertService.shared.alertErrorMsg("Not valid Secret Code")
                return
            }
            if replacing {
                AlertService.shared.alertSuccessMsg("Another user already registered with this secret code. The previous user will be signed out.")
            }
            self.manager.dismissBulletin()
            self.callback?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text! == "" {
            return false
        } else if textField == page.word1Input.textField {
            textField.resignFirstResponder()
            page.word2Input.becomeFirstResponder()
            return true
        } else if textField == page.numberInput.textField {
            textField.resignFirstResponder()
            page.word2Input.becomeFirstResponder()
            return true
        } else if textField == page.word2Input.textField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}
