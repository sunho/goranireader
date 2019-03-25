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
    
    @objc public var usernameInput: LineInputField!
    @objc public var passwordInput: LineInputField!
    @objc public var emailInput: LineInputField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override init() {
        super.init(title: "회원가입")
        descriptionText =  ""
        
        actionButtonTitle = "완료"
        alternativeButtonTitle = "취소"
        
        appearance.actionButtonColor = Color.tint
        appearance.alternativeButtonTitleColor = Color.tint
        appearance.actionButtonTitleColor = .white
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        usernameInput = LineInputField()
        usernameInput.placeholder = "아이디"
        passwordInput = LineInputField()
        passwordInput.placeholder = "비밀번호"
        emailInput = LineInputField()
        emailInput.placeholder = "이메일"
        return [InputFormView(views: [usernameInput, passwordInput, emailInput])]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }
    
}
