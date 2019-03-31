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
    
    var usernameInput: LineInputField!
    var passwordInput: LineInputField!
    var emailInput: LineInputField!
    var container: UIView!
    
    init(_ delegate: UITextFieldDelegate?) {
        super.init(title: "회원가입")
        descriptionText =  ""
        
        actionButtonTitle = "완료"
        alternativeButtonTitle = "취소"
        
        appearance.actionButtonColor = Color.tint
        appearance.alternativeButtonTitleColor = Color.tint
        appearance.actionButtonTitleColor = .white
        
        usernameInput = LineInputField(frame: CGRect(), delegate: delegate)
        usernameInput.textField.returnKeyType = .next
        usernameInput.placeholder = "아이디"
        passwordInput = LineInputField(frame: CGRect(), delegate: delegate)
        passwordInput.textField.returnKeyType = .next
        passwordInput.placeholder = "비밀번호"
        passwordInput.textField.isSecureTextEntry = true
        emailInput = LineInputField(frame: CGRect(), delegate: delegate)
        emailInput.placeholder = "이메일"
        emailInput.textField.keyboardType = .emailAddress
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        print("?")
        print(self)
        print(emailInput)
        print(emailInput.textField)
        print(emailInput.textField.delegate)
        container = InputFormView(views: [usernameInput, emailInput, passwordInput])
        return [container]
    }
    
    override func tearDown() {
        super.tearDown()
        usernameInput.textField.text = nil
        passwordInput.textField.text = nil
        emailInput.textField.text = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }
}
