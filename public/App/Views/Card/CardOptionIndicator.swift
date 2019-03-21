//https://github.com/saoudrizwan/CardSlider

import Foundation
import UIKit

class CardOptionIndicator: UIView {
    
    let emojiPadding: CGFloat = 20
    let emojiSize = CGSize(width: 48, height: 48)
    let emojiInitialOffset: CGFloat = 90
    let emojiInitialAlpha: CGFloat = 0.45
    
    let like1Emoji = UIImageView(image: UIImage(named: "easy_face_icon"))
    let like2Emoji = UIImageView(image: UIImage(named: "medium_face_icon"))
    
    let dislike1Emoji = UIImageView(image: UIImage(named: "difficult_face_icon"))
    let dislike2Emoji = UIImageView(image: UIImage(named: "retry_face_icon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        like1Emoji.frame = CGRect(x: frame.width - emojiPadding - emojiSize.width, y: (frame.height/2) - (emojiSize.height * 1.5) - emojiPadding, width: emojiSize.width, height: emojiSize.height)
        self.addSubview(like1Emoji)
        
        like2Emoji.frame = CGRect(x: frame.width - emojiPadding - emojiSize.width, y: (frame.height/2) - (emojiSize.height * 0.5), width: emojiSize.width, height: emojiSize.height)
        self.addSubview(like2Emoji)
        
        dislike1Emoji.frame = CGRect(x: emojiPadding, y: (frame.height/2) - (emojiSize.height * 1.5) - emojiPadding, width: emojiSize.width, height: emojiSize.height)
        self.addSubview(dislike1Emoji)
        
        dislike2Emoji.frame = CGRect(x: emojiPadding, y: (frame.height/2) - (emojiSize.height * 0.5), width: emojiSize.width, height: emojiSize.height)
        self.addSubview(dislike2Emoji)
        
        // initial state
        like1Emoji.alpha = emojiInitialAlpha
        like1Emoji.frame.origin.x += emojiInitialOffset
        
        like2Emoji.alpha = emojiInitialAlpha
        like2Emoji.frame.origin.x += emojiInitialOffset

        dislike1Emoji.alpha = emojiInitialAlpha
        dislike1Emoji.frame.origin.x -= emojiInitialOffset
        
        dislike2Emoji.alpha = emojiInitialAlpha
        dislike2Emoji.frame.origin.x -= emojiInitialOffset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Smiley Emojis
    
    var isLikeEmojisVisible = false
    var isDislikeEmojisVisible = false
    
    public func showEmoji(for option: CardOption) {
        if option == .easy || option == .medium {
            
            if isDislikeEmojisVisible {
                hideDislikeEmojis()
            }
            
            if !isLikeEmojisVisible {
                showLikeEmojis()
            }
            
            like1Emoji.alpha = emojiInitialAlpha
            like2Emoji.alpha = emojiInitialAlpha
            switch option {
            case .easy:
                like1Emoji.alpha = 1
            case .medium:
                like2Emoji.alpha = 1
            default:
                break
            }
            
        } else {
            if isLikeEmojisVisible {
                hideLikeEmojis()
            }
            
            if !isDislikeEmojisVisible {
                showDislikeEmojis()
            }
            
            dislike1Emoji.alpha = emojiInitialAlpha
            dislike2Emoji.alpha = emojiInitialAlpha
            switch option {
            case .difficult:
                dislike1Emoji.alpha = 1
            case .retry:
                dislike2Emoji.alpha = 1
            default:
                break
            }
        }
    }
    
    public func hideFaceEmojis() {
        if isLikeEmojisVisible {
            hideLikeEmojis()
        }
        if isDislikeEmojisVisible {
            hideDislikeEmojis()
        }
    }
    
    var isHidingLikeEmojis = false
    private func hideLikeEmojis() {
        if isHidingLikeEmojis { return }
        isHidingLikeEmojis = true
        UIView.animate(withDuration: 0.2, delay: 0.0,  options: [], animations: {
            self.like1Emoji.frame.origin.x += self.emojiInitialOffset
            self.like2Emoji.frame.origin.x += self.emojiInitialOffset
        }) { (_) in
            self.isHidingLikeEmojis = false
        }
        isLikeEmojisVisible = false
    }
    
    var isShowingLikeEmojis = false
    private func showLikeEmojis() {
        if isShowingLikeEmojis { return }
        isShowingLikeEmojis = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.like1Emoji.frame.origin.x -= self.emojiInitialOffset
            self.like2Emoji.frame.origin.x -= self.emojiInitialOffset
        }) { (_) in
            self.isShowingLikeEmojis = false
        }
        isLikeEmojisVisible = true
    }
    
    var isHidingDislikeEmojis = false
    private func hideDislikeEmojis() {
        if isHidingDislikeEmojis { return }
        isHidingDislikeEmojis = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.dislike1Emoji.frame.origin.x -= self.emojiInitialOffset
            self.dislike2Emoji.frame.origin.x -= self.emojiInitialOffset
        }) { (_) in
            self.isHidingDislikeEmojis = false
        }
        isDislikeEmojisVisible = false
    }
    
    var isShowingDislikeEmojis = false
    private func showDislikeEmojis() {
        if isShowingDislikeEmojis { return }
        isShowingDislikeEmojis = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.dislike1Emoji.frame.origin.x += self.emojiInitialOffset
            self.dislike2Emoji.frame.origin.x += self.emojiInitialOffset
        }) { (_) in
            self.isShowingDislikeEmojis = false
        }
        isDislikeEmojisVisible = true
    }
}
