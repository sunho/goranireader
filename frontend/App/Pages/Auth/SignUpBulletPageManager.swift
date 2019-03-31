import Foundation
import BLTNBoard

class SignupBulletPageManager: NSObject, UITextFieldDelegate {
    fileprivate var page: SignUpBulletPage!
    fileprivate var manager: BLTNItemManager!
    
    override init() {
        super.init()
        page = SignUpBulletPage(self)
        page.alternativeHandler = didCancel
        page.actionHandler = didAction
        manager = BLTNItemManager(rootItem: page)
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
                    case .value(_):
                        self.manager.dismissBulletin()
                    case .failed(let error):
                        AlertService.shared.alertError(error)
                    default:
                        print(event)
                    }
                }
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("aSFASfasdf")
        if textField.text! == "" {
            return false
        } else if textField == page.usernameInput.textField {
            textField.resignFirstResponder()
            page.passwordInput.becomeFirstResponder()
            return true
        } else if textField == page.emailInput.textField {
            textField.resignFirstResponder()
            page.passwordInput.becomeFirstResponder()
            return true
        } else if textField == page.passwordInput.textField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}
