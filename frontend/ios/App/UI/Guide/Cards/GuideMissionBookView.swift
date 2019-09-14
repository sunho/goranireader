//
//  GuideMissionBookView.swift
//  app
//
//  Created by Sunho Kim on 14/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class GuideMissionBookView: UIView {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var  nameView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var dueView: UILabel!
    @IBOutlet weak var msgView: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

