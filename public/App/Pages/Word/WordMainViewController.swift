import UIKit

class WordMainViewController: UIViewController, CardSliderDelegate, WordCardViewControllerDelegate {
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
        words[0].word = "hello"
        words[0].memory = "HOOOOasdf asdf asddf asdf asdf adsf asdf sadf asdf asdf asdfdsaf sa"
        var def = UnknownWordDefinition()
        def.definition = "HOOOOasdf asdf asddf asdf asdf adsf asdf sadf asdf asdf asdfdsaf sa"
        var ex = UnknownWordExample()
        ex.sentence = "231423143214"
        def.examples.append(ex)
        words[0].definitions.append(def)
        words.append(words[0])
        words.append(words[0])
        words.append(words[0])
        words.append(words[0])
        
        cardSliderContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight))
        cardSliderContainer.clipsToBounds = false
        cardSlider = CardSlider(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: cardHeight), delegate: self)
        cardSliderContainer.addSubview(cardSlider)
        view.addSubview(cardSliderContainer)
        view.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardSliderContainer.frame.origin.y = 80
        cardSliderContainer.center.x = view.center.x
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memoryForm.prepare()
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
