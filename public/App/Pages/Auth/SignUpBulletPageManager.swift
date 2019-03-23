import Foundation
import BLTNBoard

class SignupBulletPageManager {
    fileprivate let page = SignUpBulletPage()
    fileprivate var manager: BLTNItemManager
    
    init() {
        manager = BLTNItemManager(rootItem: page)
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
    }
    
    func show(above: UIViewController) {
        manager.showBulletin(above: above)
    }
    
    func didCancel(_ item: BLTNItem) {
        manager.dismissBulletin()
    }
    
    func didAction(_ item: BLTNItem) {
        let page = item as! SignUpBulletPage
        let username = page.usernameInput.textField.text ?? ""
        let password = page.passwordInput.textField.text ?? ""
        let email = page.emailInput.textField.text ?? ""
        APIService.shared.request(.register(username: username, password: password, email: email))
            .filterSuccessfulStatusCodes()
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let resp):
                        self.manager.dismissBulletin()
                    case .failed(let error):
                        AlertService.shared.alertError(error)
                    default:
                        print(event)
                    }
                }
            }
    }
}
