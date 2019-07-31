//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import BLTNBoard

class FeedbackBulletPage: BLTNPageItem {
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func actionButtonTapped(sender: UIButton) {
        
        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        // Call super
        super.actionButtonTapped(sender: sender)
        
    }
    
    override func alternativeButtonTapped(sender: UIButton) {
        
        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        // Call super
        super.alternativeButtonTapped(sender: sender)
        
    }
    
}
