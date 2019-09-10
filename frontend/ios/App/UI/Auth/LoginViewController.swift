//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import BLTNBoard
import UIKit

class LoginViewController: UIViewController  {
    var loginForm: LoginBulletPageManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginForm = LoginBulletPageManager()
        loginForm.callback = checkAuth
        checkAuth()
    }
    
    @IBAction func getStarted(_ sender: Any) {
        loginForm.show(above: self)
    }
    
    func checkAuth() {
        
    }
}
