//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import CoreData
import Moya
import ReactiveSwift
import IQKeyboardManagerSwift
import GoogleSignIn
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = "707156763693-4eu17nhnucmi4io3c10gm6abvr4ue630.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        APIService.shared // TODO: find another way
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController: UIViewController = RealmService.shared.getConfig().authorized ? storyboard.createTabViewController() : storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        print(FileUtil.sharedDir)
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            APIService.shared.request(.login(username: user.profile.name, idToken: user.authentication.idToken))
                .filterSuccessfulStatusCodes()
                .start { event in
                    DispatchQueue.main.async {
                        switch event {
                        case .value(let resp):
                            APIService.shared.token = String(data: resp.data, encoding: .utf8)
                        case .failed(let error):
                            if !error.isOffline {
                                AlertService.shared.alertError(error)
                            }
                            print(error)
                        default:
                            print(event)
                        }
                    }
            }
        }
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

