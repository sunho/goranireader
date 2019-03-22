//
//  LoginViewController.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import BLTNBoard
import UIKit
import Moya
import ReactiveSwift

class LoginViewController: UIViewController {
    
    var signUpForm: BLTNItemManager!

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuth()
        let item = SignUpBulletPage()
        signUpForm = BLTNItemManager(rootItem: item)
    }
    
    func checkAuth() {
        APIService.shared.request(.checkAuth)
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case let .value(resp):
                        if resp.statusCode == 200 {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                    case .failed(let error):
                        if error.isOffline {
                            if RealmService.shared.getConfig().authorized {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
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

    @IBAction func login(_ sender: Any) {
        APIService.shared.request(.login(username: usernameInput.text!, password: passwordInput.text!))
            .filterSuccessfulStatusCodes()
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let resp):
                        APIService.shared.token = String(data: resp.data, encoding: .utf8)
                        self.checkAuth()
                    case .failed(let error):
                        if !error.isOffline {
                            AlertService.shared.alertError(error)
                        }
                    default:
                        print(event)
                    }
                }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
}
