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
        
        APIService.shared.request(.listBooks)
            .filterSuccessfulStatusCodes()
            .map([Book].self)
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let books):
                        let owned = books.filter({b in b.id == self.book.id}).count != 0
                        if owned {
                            self.button.isEnabled = false
                        }
                    default:
                        print(event)
                    }
                }
        }
    }
    
    @IBAction func purchase(_ sender: Any) {
        APIService.shared.request(.buyShopBook(bookId: book.id))
            .filterSuccessfulStatusCodes()
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let resp):
                        NotificationCenter.default.post(name: .didPurchaseBook, object: nil)
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
