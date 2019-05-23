//
// Copyright © 2019 Sunho Kim. All rights reserved.
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
            .handle(ignoreError: false) { offline, _ in
                if !offline {
                    let vc = self.storyboard!.createTabViewController()
                    self.present(vc, animated: true, completion: nil)
                } else {
                    if RealmService.shared.getConfig().authorized {
                        let vc = self.storyboard!.createTabViewController()
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
    }
}
