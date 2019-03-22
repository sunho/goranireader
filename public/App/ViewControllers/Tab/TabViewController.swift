import UIKit
import RealmSwift

protocol TabViewControllerDelegate {
    var sideView: UIView { get }
}

class TabViewController: UIViewController, UITabBarDelegate {
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var selectedIndex: Int = 0
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let bookMainViewController = self.storyboard!.instantiateViewController(withIdentifier: "BookMainViewController")
        let wordMainViewController = self.storyboard!.instantiateViewController(withIdentifier: "WordMainViewController")
        let storeMainViewController = self.storyboard!.instantiateViewController(withIdentifier: "StoreMainViewController")
        let recommendMainViewController = self.storyboard!.instantiateViewController(withIdentifier: "RecommendMainViewController")
        
        self.viewControllers = [bookMainViewController, wordMainViewController,  recommendMainViewController, storeMainViewController]
        self.tabBar.delegate = self
        self.tabBar.selectedItem = self.tabBar.items![0]
        self.tabBar(self.tabBar, didSelect: self.tabBar.items![0])
        self.layout()

        contentView.clipsToBounds = false
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print(FileUtil.booksDir)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let previousVC = viewControllers[self.selectedIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        if let delegate = previousVC as? TabViewControllerDelegate {
            delegate.sideView.removeFromSuperview()
        }
        
        self.selectedIndex = item.tag
        
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
    
    fileprivate func layout() {
    }
}
