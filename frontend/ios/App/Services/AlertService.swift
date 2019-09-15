//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import SwiftEntryKit

// TODO i18n
class AlertService {
    fileprivate var bottomErrorAttr = EKAttributes()
    fileprivate var bottomSuccessAttr = EKAttributes()
    static var shared = AlertService()
    
    init() {
        bottomErrorAttr.position = .bottom
        bottomErrorAttr.precedence = .override(priority: .high, dropEnqueuedEntries: false)
        bottomErrorAttr.entryBackground = .color(color: Color.red)
        bottomSuccessAttr.position = .bottom
        bottomSuccessAttr.precedence = .override(priority: .high, dropEnqueuedEntries: false)
        bottomSuccessAttr.entryBackground = .color(color: Color.green)
    }
    
    func alert(attributes: EKAttributes, title: String, description: String, imageName: String? = nil) {
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 17, weight: .medium), color: Color.white))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont.systemFont(ofSize: 14), color: Color.white))
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = .init(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func alertSuccessMsg(_ msg: String) {
        alert(attributes: bottomSuccessAttr, title: "Success", description: msg)
    }
    
    func alertErrorMsg(_ msg: String) {
        alert(attributes: bottomErrorAttr, title: "Error", description: msg)
    }
    
    func alertError(_ error: GoraniError) {
        
    }
}
