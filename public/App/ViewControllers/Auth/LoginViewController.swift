//
//  LoginViewController.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import Moya
import ReactiveSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuth()
        // Do any additional setup after loading the view.
    }
    
    func checkAuth() {
        APIService.shared.request(.checkAuth)
            .start { event in
                switch event {
                case .value(let resp):
                    if resp.statusCode == 200 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                default:
                    print(event)
                }
            }
    }

    @IBAction func login(_ sender: Any) {
        APIService.shared.request(.login(username: usernameInput.text!, password: passwordInput.text!))
            .filterSuccessfulStatusCodes()
            .start { event in
            switch event {
            case .value(let resp):
                APIService.shared.token = String(data: resp.data, encoding: .utf8)
                self.checkAuth()
            default:
                print(event)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
