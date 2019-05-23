//
//  MemoryBulletPage.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import BLTNBoard

class SocialCommentBulletPage: FeedbackBulletPage {
    
    @objc public var commentInput: LineTextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override init() {
        super.init(title: "댓글 작성")
        descriptionText =  "답변이나 의견을 입력해주세요."
        
        actionButtonTitle = "완료"
        alternativeButtonTitle = "취소"
        
        appearance.actionButtonColor = Color.tint
        appearance.alternativeButtonTitleColor = Color.tint
        appearance.actionButtonTitleColor = .white
        appearance.descriptionFontSize = 17
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        commentInput = LineTextField()
        commentInput.placeholder = "내용"
        return [commentInput]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }
    
}
