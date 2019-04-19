//
//  LoginViewController.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import BLTNBoard
import GoogleSignIn
import UIKit
import Moya
import ReactiveSwift

class LoginViewController: UIViewController, GIDSignInUIDelegate  {
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        APIService.shared.request(.checkAuth)
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case let .value(resp):
                        if resp.statusCode == 200 {
                            let vc = self.storyboard!.createTabViewController()
                            self.present(vc, animated: true, completion: nil)
                        }
                    case .failed(let error):
                        if error.isOffline {
                            if RealmService.shared.getConfig().authorized {
                                let vc = self.storyboard!.createTabViewController()
                                self.present(vc, animated: true, completion: nil)
                            }
                        } else {
                            AlertService.shared.alertError(error)
                        }
                    default:
                        print(event)
                    }
                }
        }
    }
}
