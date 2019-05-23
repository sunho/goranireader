//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class StoreBookDetailViewController: UIViewController {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var nativeNameView: UILabel!
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var button: RoundButton!
    
    var owned: Bool!
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
        
        if let cover = URL(string: book.cover) {
            coverView.kf.setImage(with: Source.network(ImageResource(downloadURL: cover)), placeholder: UIImage(named: "book_placeholder"))
        }
        nameView.text = book.name
        nativeNameView.text = book.nativeName
        
        typeStackView.removeAllArrangedSubviews()
        
        for type in book.types {
            typeStackView.addArrangedSubview(
                ContentTypeIconView(type: type)
            )
        }
        
        button.setTitle("보유중", for: .disabled)
        
        if owned {
            button.isEnabled = false
        }
    }
    
    @IBAction func purchase(_ sender: Any) {
        if !owned {
            APIService.shared.request(.buyShopBook(bookId: book.id))
                .filterSuccessfulStatusCodes()
                .start { event in
                    DispatchQueue.main.async {
                        switch event {
                        case .value(let resp):
                            NotificationCenter.default.post(name: .didPurchaseBook, object: nil)
                            self.owned = true
                            self.button.isEnabled = false
                            
                        case .failed(let error):
                            AlertService.shared.alertError(error)
                        default:
                            print(event)
                        }
                    }
            }
        }
    }
}
