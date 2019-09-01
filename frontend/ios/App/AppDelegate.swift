//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController: UIViewController = RealmService.shared.getConfig().authorized ? storyboard.createTabViewController() : storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        print(FileUtil.sharedDir)
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }
}

