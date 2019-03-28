//https://github.com/saoudrizwan/CardSlider

import Foundation
import UIKit

protocol CardSliderDelegate {
    func cardSlider(_ cardSlider: CardSlider, itemAt: Int) -> CardView
    func cardSlider(_ cardSlider: CardSlider, numberOfItems: ()) -> Int
    func cardSliderDidProceed(_ cardSlider: CardSlider, index: Int, option: CardAnswerQuality)
    func cardSliderDidClear(_ cardSlider: CardSlider)
    func cardSliderShouldSlide(_ cardSlider: CardSlider) -> Bool
}

extension CardSliderDelegate {
    func cardSliderDidProceed(_ cardSlider: CardSlider, option: CardAnswerQuality) {}
    func cardSliderDidClear(_ cardSlider: CardSlider) {}
    func cardSliderShouldSlide(_ cardSlider: CardSlider) -> Bool { return true }
}

fileprivate let factorY: CGFloat = 0.72 // TODO

class CardSlider: UIView {
    var delegate: CardSliderDelegate!
    fileprivate var cardIsHiding = false
    fileprivate var dynamicAnimator: UIDynamicAnimator!
    fileprivate var cardAttachmentBehavior: UIAttachmentBehavior!
    fileprivate var cards: [CardView] = []
    fileprivate var cardOptionIndicator: CardOptionIndicator!
    fileprivate let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    fileprivate let cardInteritemSpacing: CGFloat = 15
    fileprivate var currentOption: CardAnswerQuality?
    
    init(frame: CGRect, delegate: CardSliderDelegate) {
        super.init(frame: frame)
        clipsToBounds = false
        self.delegate = delegate
        dynamicAnimator = UIDynamicAnimator(referenceView: self)
        cardOptionIndicator = CardOptionIndicator(frame: self.frame)
        self.addSubview(cardOptionIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        for i in 0...3 {
            if i >= cards.count { break }
            cards[i].removeFromSuperview()
        }
        
        currentOption = nil
        cardIsHiding = false
        cards = []
        
        let len = delegate.cardSlider(self, numberOfItems: ())
        if len == 0 {
            return
        }
        
        for i in 0..<len {
            let card = delegate.cardSlider(self, itemAt: i)
            card.index = i
            card.isUserInteractionEnabled = false
            cards.append(card)
        }
        
        let firstCard = cards[0]
        self.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(len)
        firstCard.center.x = self.center.x
        firstCard.contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        firstCard.isUserInteractionEnabled = true
        
        // the next 3 cards in the deck
        for i in 1...3 {
            if i >= len { break }
            cards[i].layer.zPosition = CGFloat(cards.count - i)
            self.addSubview(cards[i])
        }
        
        self.bringSubviewToFront(firstCard)
        layoutCards()
    }
    
    func layoutCards() {
        for i in 0...3 {
            if i >= cards.count { break }
            let card = cards[i]
            
            // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 4 cards visible to the user
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            // workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            
            card.center.x = self.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
        }
    }
    
    /// This is called whenever the front card is swiped off the screen or is animating away from its initial position.
    /// showNextCard() just adds the next card to the 4 visible cards and animates each card to move forward.
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center.x = self.center.x
                    card.frame.origin.y = 0
                } else {
                    card.center.x = self.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.contentView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
            
        }
        
        // 2. add a new card (now the 4th card in the deck) to the very back
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.bringSubviewToFront(cards[1])
                self.cards[1].isUserInteractionEnabled = true
            } else {
                self.cards[0].isUserInteractionEnabled = true
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            
        })
        // first card needs to be in the front for proper interactivity
        self.bringSubviewToFront(self.cards[1])
        self.cards[1].isUserInteractionEnabled = true
    }
    
    func removeOldFrontCard() {
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
        if cards.count == 0 {
            delegate.cardSliderDidClear(self)
        }
    }
    
    @objc func handleCardPan(sender: UIPanGestureRecognizer) {
        if !delegate.cardSliderShouldSlide(self) {
            return
        }
        if cardIsHiding {
            return
        }
        // change this to your discretion - it represents how far the user must pan up or down to change the option
        let optionLength: CGFloat = 10
        // distance user must pan right or left to trigger an option
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: self)
        let panLocationInCard = sender.location(in: cards[0])
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffset(horizontal: panLocationInCard.x - cards[0].bounds.midX, vertical: panLocationInCard.y - cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            if cards[0].center.x > (self.center.x + requiredOffsetFromCenter) {
                if cards[0].center.y * factorY < (self.center.y * factorY - optionLength) {
                    cards[0].showOptionLabel(option: .easy)
                    cardOptionIndicator.showEmoji(for: .easy)
                    currentOption = .easy
                    
                } else {
                    cards[0].showOptionLabel(option: .medium)
                    cardOptionIndicator.showEmoji(for: .medium)
                    currentOption = .medium
                }
            } else if cards[0].center.x < (self.center.x - requiredOffsetFromCenter) {
                if cards[0].center.y * factorY < (self.center.y * factorY  - optionLength) {
                    cards[0].showOptionLabel(option: .difficult)
                    cardOptionIndicator.showEmoji(for: .difficult)
                    currentOption = .difficult
                } else {
                    cards[0].showOptionLabel(option: .retry)
                    cardOptionIndicator.showEmoji(for: .retry)
                    currentOption = .retry
                }
            } else {
                cards[0].hideOptionLabel()
                cardOptionIndicator.hideFaceEmojis()
                currentOption = nil
            }
        case .ended:
            dynamicAnimator.removeAllBehaviors()
            if !(cards[0].center.x > (self.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.center.x - requiredOffsetFromCenter)) || currentOption == nil {
                // snap to center
                let snapBehavior = UISnapBehavior(item: cards[0], snapTo: CGPoint(x: self.center.x, y: self.center.y))
                dynamicAnimator.addBehavior(snapBehavior)
            } else {
                let velocity = sender.velocity(in: self)
                let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                pushBehavior.magnitude = 175
                dynamicAnimator.addBehavior(pushBehavior)
                // spin after throwing
                var angular = CGFloat.pi / 2 // angular velocity of spin
                
                let currentAngle: Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                
                if currentAngle > 0 {
                    angular = angular * 1
                } else {
                    angular = angular * -1
                }
                let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                dynamicAnimator.addBehavior(itemBehavior)
                delegate.cardSliderDidProceed(self, index: cards[0].index!, option: currentOption!)
                showNextCard()
                hideFrontCard()
            }
        default:
            break
        }
    }

    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.bounds.contains(self!.cards[0].center)) {
                    cardRemoveTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self?.cards[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removeOldFrontCard()
                        self?.cardIsHiding = false
                    })
                }
            })
        } else {
            // fallback for earlier versions
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }

    func clear() {
        
    }
}
