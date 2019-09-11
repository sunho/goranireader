//
//  SignUpForm.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//
import Foundation
import BLTNBoard

class LoginBulletPage: FeedbackBulletPage {
    
    var word1Input: LineInputField!
    var word2Input: LineInputField!
    var numberInput: LineInputField!
    var container: UIView!
    
    init(_ delegate: UITextFieldDelegate?) {
        super.init(title: "Login")
        descriptionText =  ""
        
        actionButtonTitle = "Okay"
        alternativeButtonTitle = "Cancel"
        
        appearance.actionButtonColor = Color.tint
        appearance.alternativeButtonTitleColor = Color.tint
        appearance.actionButtonTitleColor = .white
        
        word1Input = LineInputField(frame: CGRect(), delegate: delegate)
        word1Input.textField.returnKeyType = .next
        word1Input.placeholder = "First Word"
        word2Input = LineInputField(frame: CGRect(), delegate: delegate)
        word2Input.textField.returnKeyType = .next
        word2Input.placeholder = "Second Word"
        numberInput = LineInputField(frame: CGRect(), delegate: delegate)
        numberInput.placeholder = "Number"
        numberInput.textField.keyboardType = .numberPad
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        container = InputFormView(views: [word1Input, word2Input, numberInput])
        return [container]
    }
    
    override func tearDown() {
        super.tearDown()
        word1Input.textField.text = nil
        word2Input.textField.text = nil
        numberInput.textField.text = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }
}
