import UIKit

class WordMainViewController: UIViewController, CardSliderDelegate, WordCardViewControllerDelegate {
    var cardDetailOpen: Bool = false
    var cardOpen: Bool = false
    var cardSliderContainer: UIView!
    var cardSlider: CardSlider!
    var words: [UnknownWord] = [UnknownWord()]
    var cardHeight: CGFloat {
        return cardWidth * 1.3
    }
    var cardWidth: CGFloat {
        let size = UIScreen.main.bounds.size
        return size.width * 0.55
    }
    
    override func viewDidLoad() {
        words[0].word = "asfd"
        words[0].memory = "HOOOO"
        var def = UnknownWordDefinition()
        def.definition = "asdf2342214123"
        var ex = UnknownWordExample()
        ex.sentence = "231423143214"
        def.examples.append(ex)
        words[0].definitions.append(def)
        
        cardSliderContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight))
        cardSliderContainer.clipsToBounds = false
        cardSlider = CardSlider(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight), delegate: self)
        cardSliderContainer.addSubview(cardSlider)
        view.addSubview(cardSliderContainer)
        view.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardSliderContainer.frame.origin.y = 50
        cardSliderContainer.center.x = view.center.x
    }
    
    func cardSlider(_ cardSlider: CardSlider, itemAt: Int) -> CardView {
        let vc = WordCardViewController(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
        vc.delegate = self
        addChild(vc)
        vc.word = words[itemAt]
        vc.didMove(toParent: self)
        return vc.cardView
    }
    
    func cardSlider(_ cardSlider: CardSlider, numberOfItems: ()) -> Int {
        return words.count
    }
    
    func cardSliderDidProceed(_ cardSlider: CardSlider, index: Int, option: CardOption) {
        cardOpen = false
        cardDetailOpen = false
    }
    
    func wordCardViewDidFlip() {
        cardOpen = true
    }
    
    func wordCardViewDidOpenDetail() {
        cardDetailOpen = true
    }
    
    func wordCardViewDidHideDetail() {
        cardDetailOpen = false
    }
    
    func cardSliderShouldSlide(_ cardSlider: CardSlider) -> Bool {
        return cardOpen && !cardDetailOpen
    }
}
