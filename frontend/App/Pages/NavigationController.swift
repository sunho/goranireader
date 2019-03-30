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
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//        navigationBar.setBackgroundImage(UIImage.imageWithColor(tintColor: .white), for: .default)
//        view.backgroundColor = UIColor.white
        for viewController in tabBarController?.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    func addShadow() {
        navigationBar.shadowImage = UIImage.imageWithColor(tintColor: .white)
        navigationBar.layer.borderColor = UIColor.clear.cgColor
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowRadius = 4
        navigationBar.layer.shadowOpacity = 0.1
    }
    
    func removeShadow() {
        navigationBar.layer.shadowRadius = 0
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0)
    }
}
