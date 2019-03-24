//
//  StoeDetailViewController.swift
//  app
//
//  Created by sunho on 2019/03/24.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import Kingfisher

class StoreBookDetailViewController: UIViewController {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var nativeNameView: UILabel!
    @IBOutlet weak var typeStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction func purchase(_ sender: Any) {
        APIService.shared.request(.buyShopBook(bookId: book.id))
            .filterSuccessfulStatusCodes()
            .start { event in
            DispatchQueue.main.async {
                switch event {
                case .value(let resp):
                    NotificationCenter.default.post(name: .didPurchaseBook, object: nil)
                case .failed(let error):
                    AlertService.shared.alertError(error)
                default:
                    print(event)
                }
            }
        }
    }
}
