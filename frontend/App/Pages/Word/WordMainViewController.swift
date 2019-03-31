import UIKit

class WordMainViewController: UIViewController, CardSliderDelegate, WordCardViewControllerDelegate {
    @IBOutlet weak var remainView: UILabel!
    @IBOutlet weak var clickIcon: UIImageView!
    @IBOutlet weak var leftIcon: UIView!
    @IBOutlet weak var rightIcon: UIView!
    
    var memoryForm: MemoryBulletPageManager!
    var cardDetailOpen: Bool = false
    var cardOpen: Bool = false
    var cardSliderContainer: UIView!
    var cardSlider: CardSlider!
    var words: [UnknownWord] = [UnknownWord()]
    var cardHeight: CGFloat {
        return cardWidth * 1.2
    }
    var cardWidth: CGFloat {
        let size = UIScreen.main.bounds.size
        return size.width * 0.8
    }
    
    override func viewDidLoad() {
        memoryForm = MemoryBulletPageManager()
        
        cardSliderContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight))
        cardSliderContainer.clipsToBounds = false
        cardSlider = CardSlider(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight), delegate: self)
        cardSliderContainer.addSubview(cardSlider)
        view.addSubview(cardSliderContainer)
        view.clipsToBounds = false
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardSliderContainer.frame.origin.y = 150 + (navigationController?.navigationBar.frame.size.height ?? 0)
        cardSliderContainer.center.x = view.center.x
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memoryForm.prepare()
        words = RealmService.shared.getTodayUnknownWords().shuffled()
        updateRemainView()
        layout()
        cardSlider.reload()
    }
    
    func cardSlider(_ cardSlider: CardSlider, itemAt: Int) -> CardView {
        let vc = WordCardViewController(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
        vc.delegate = self
        addChild(vc)
        vc.word = words[itemAt]
        vc.didMove(toParent: self)
        vc.memoryForm = memoryForm
        return vc.cardView
    }
    
    func layout() {
        if cardOpen {
            leftIcon.isHidden = false
            rightIcon.isHidden = false
            clickIcon.isHidden = true
            if cardDetailOpen {
                leftIcon.isHidden = true
                rightIcon.isHidden = true
            }
        } else {
            leftIcon.isHidden = true
            rightIcon.isHidden = true
            clickIcon.isHidden = false
        }
    }
    
    func updateRemainView() {
        remainView.text = "\(RealmService.shared.getTodayUnknownWords().count)"
    }
    
    func cardSlider(_ cardSlider: CardSlider, numberOfItems: ()) -> Int {
        return words.count
    }
    
    func cardSliderDidProceed(_ cardSlider: CardSlider, index: Int, option: CardAnswerQuality) {
        cardOpen = false
        cardDetailOpen = false
        RealmService.shared.write {
            words[index].update(option)
            NotificationCenter.default.post(name: .unknownWordAdded, object: nil)
        }
        updateRemainView()
        layout()
    }
    
    func cardSliderDidClear(_ cardSlider: CardSlider) {
        words = RealmService.shared.getTodayUnknownWords().shuffled()
        if words.count == 0 {
            return
        }
        cardSlider.reload()
    }
    
    func wordCardViewDidFlip() {
        cardOpen = true
        layout()
    }
    
    func wordCardViewDidOpenDetail() {
        cardDetailOpen = true
        layout()
    }
    
    func wordCardViewDidHideDetail() {
        cardDetailOpen = false
        layout()
    }
    
    func cardSliderShouldSlide(_ cardSlider: CardSlider) -> Bool {
        return cardOpen && !cardDetailOpen
    }
}
