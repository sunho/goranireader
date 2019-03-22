//
//  SignUpForm.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import BLTNBoard

class SignUpBulletPage: FeedbackBulletPage {
    
    @objc public var textField: UITextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "First and Last Name", returnKey: .done, delegate: nil)
        return [textField]
    }
    
    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
    
}
