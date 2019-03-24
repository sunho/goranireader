//
//  NavigationController.swift
//  app
//
//  Created by sunho on 2019/03/24.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        navigationBar.prefersLargeTitles = true
        for viewController in tabBarController?.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }
}
