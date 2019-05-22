//
//  SocialSharedDetailViewController.swift
//  app
//
//  Created by sunho on 2019/03/31.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class SocialDetailViewController: UIViewController {
    var post: Post!
    
    override func viewDidLoad() {
        modalPresentationStyle = .overFullScreen
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
}
