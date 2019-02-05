import UIKit

protocol TabViewControllerDelegate {
    var sideView: UIView { get }
}

class TabViewController: UIViewController {
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var bookTabButton: UIButton!
    @IBOutlet weak var wordbookTabButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    var selectedIndex: Int = 0
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let bookViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookMainViewController")
        let wordbookViewController = self.storyboard!.instantiateViewController(withIdentifier: "WordbookMainViewController")
        let storeMainViewController = self.storyboard!.instantiateViewController(withIdentifier: "StoreMainViewController")
        
        self.viewControllers = [bookViewController, wordbookViewController, storeMainViewController]
        self.didPressTab(self.buttons[0])
        
        self.layout()
    }
    
    fileprivate func layout() {
        UIUtill.dropShadow(self.tabBarView, offset: CGSize(width: 0, height: -2), radius: 3)
    }
    
    @IBAction func didPressTab(_ sender: UIButton) {
        self.buttons[self.selectedIndex].isSelected = false
        
        let previousVC = viewControllers[self.selectedIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        if let delegate = previousVC as? TabViewControllerDelegate {
            delegate.sideView.removeFromSuperview()
        }
        
        self.selectedIndex = sender.tag
        
        sender.isSelected = true
        
        let vc = self.viewControllers[self.selectedIndex]
        self.addChild(vc)
        vc.view.frame = self.contentView.bounds;
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        self.titleLabel.text = vc.title
        self.titleLabel.sizeToFit()
        self.view.layoutSubviews()

        if let delegate = vc as? TabViewControllerDelegate {
            self.sideView.addSubview(delegate.sideView)
            let frame = delegate.sideView.frame
            let frame2 = self.sideView.frame
            delegate.sideView.frame = CGRect(origin: CGPoint(x: frame2.width - frame.width, y: 0), size: frame.size)
        }
    }
}
