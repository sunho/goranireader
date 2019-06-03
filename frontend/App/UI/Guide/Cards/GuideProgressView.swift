//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class GuideProgressView: UIView {
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var dueView: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBar.layer.cornerRadius = 4
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 4
        progressBar.subviews[1].clipsToBounds = true
    }
}
