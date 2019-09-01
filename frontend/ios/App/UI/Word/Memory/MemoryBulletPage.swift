//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import BLTNBoard

class MemoryBulletPage: FeedbackBulletPage {
    
    @objc public var memoryInput: LineTextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override init() {
        super.init(title: "암기문장 수정")
        descriptionText =  "재치있는 암기문장을 만들어봅시다."
        
        actionButtonTitle = "완료"
        alternativeButtonTitle = "취소"
        
        appearance.actionButtonColor = Color.tint
        appearance.alternativeButtonTitleColor = Color.tint
        appearance.actionButtonTitleColor = .white
        appearance.descriptionFontSize = 17
    }
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        memoryInput = LineTextField()
        memoryInput.placeholder = "암기문장"
        return [memoryInput]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)
    }
    
}
