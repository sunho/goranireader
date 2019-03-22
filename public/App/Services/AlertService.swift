//
//  AlertService.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import SwiftEntryKit
import Moya

class AlertService {
    fileprivate var bottomErrorAttr = EKAttributes()
    static var shared = AlertService()
    
    init() {
        bottomErrorAttr.position = .bottom
        bottomErrorAttr.precedence = .override(priority: .high, dropEnqueuedEntries: false)
        bottomErrorAttr.entryBackground = .color(color: UIUtill.red)
    }
    
    func alert(attributes: EKAttributes, title: String, description: String, imageName: String? = nil) {
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 17, weight: .medium), color: UIUtill.white))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont.systemFont(ofSize: 14), color: UIUtill.white))
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = .init(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func alertError(_ error: MoyaError) {
        if case .underlying(let error, _) = error {
            if let error = error as? NSError {
                if error.code == -1004 {
                    alert(attributes: bottomErrorAttr, title: "에러", description: "서버가 맛이 간 것 같네요")
                }
            }
        }
    }
    
    func alertError(_ error: GoraniError) {
        
    }
}
