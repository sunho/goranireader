//
//  RecommendMainViewController.swift
//  app
//
//  Created by sunho on 2019/02/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import ReactiveSwift
import Moya

struct GuideCardProvider {
    var name: String
    var cellType: AnyClass?
    var count: () -> Int
}

class GuideMainViewController: UIViewController {
    @IBOutlet weak var targetBookView: GuideTargetBookView!
    @IBOutlet weak var progressView: GuideProgressView!
    @IBOutlet weak var wordCardView: GuideWordCardView!
    @IBOutlet weak var bookView: GuideRecommendedBookView!
    
    var shouldSelectTargetBook: Bool = false
    var targetBook: Book?
    var recommendedBooks: [Book] = []
    var wordCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        bookView.collectionView.delegate = self
        bookView.collectionView.dataSource = self
        bookView.collectionView.register(GuideRecomendedBookCell.self, forCellWithReuseIdentifier: "cell")
        var book = Book()
        book.cover = "https://w.namu.la/s/016844c98b7bffa2c183dca18f05528d0dd4154286e1e73fe84f03e3dd24aec69c9f1de04e4ccc3f6f88086306b392b129c0cfeb814918151683191fba7347670e779f353f60ab5f7f8375361dd73cc9d843add325c7e1ecc38c57ec9b3dc099"
        recommendedBooks.append(book)
        recommendedBooks.append(book)
        recommendedBooks.append(book)
        recommendedBooks.append(book)
        recommendedBooks.append(book)
       
        wordCount = RealmService.shared.getTodayUnknownWords().count
        layout()
        fetchTargetBook()
        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
    }
    
    func fetchTargetBook() {
        APIService.shared.request(.getRecommendInfo)
            .filterSuccessfulStatusCodes()
            .map(RecommendInfo.self)
            .flatMap(.latest) { info -> SignalProducer<Book, MoyaError> in
                if info.targetBookId == nil {
                    DispatchQueue.main.async {
                        self.shouldSelectTargetBook = true
                        self.layout()
                    }
                    return SignalProducer(error: MoyaError.underlying("stop", nil))
                }
                return APIService.shared.request(.getShopBook(bookId: info.targetBookId!))
                        .filterSuccessfulStatusCodes()
                        .map(Book.self)
            }.start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let book):
                        self.shouldSelectTargetBook = false
                        self.targetBook = book
                        self.layout()
                    case .failed(let error):
                        AlertService.shared.alertError(error)
                    default:
                        print(event)
                    }
                }
            }
    }
    
    @objc func unknownWordAdded(notification: Notification) {
        wordCount = RealmService.shared.getTodayUnknownWords().count
        layout()
    }
    
    @IBAction func wordCardOpen(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "WordMainViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func targetBookChange(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "StoreMainViewController") as! StoreMainViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func layout() {
        if wordCount == 0 {
            wordCardView.button.isEnabled = false
            wordCardView.textView.text = "복습해야 할 단어가 없습니다"
        } else {
            wordCardView.button.isEnabled = true
            wordCardView.textView.text = "총 \(wordCount)개의 단어를 복습해야 합니다"
        }
        
        if let targetBook = targetBook {
            targetBookView.nameView.text = targetBook.name
            targetBookView.nativeNameView.text = targetBook.nativeName
            targetBookView.coverView.setBookCover(targetBook.cover)
        }
        if shouldSelectTargetBook {
            targetBookView.nameView.text = "위의 변경 버튼을 눌러서"
            targetBookView.nativeNameView.text = "원서로 한번 읽어보고 싶은 책을 골라주세요"
            targetBookView.coverView.setBookPlaceholder()
        }
    }
}

extension GuideMainViewController: StoreMainViewControllerDelegate {
    func title() -> String {
        return "목표책 선택"
    }
    
    func storeMainViewControllerDidSelect(_ viewController: StoreMainViewController, _ book: Book) {
        navigationController?.popViewController(animated: true)
        viewController.dismiss(animated: true, completion: nil)
        var info = RecommendInfo()
        info.targetBookId = book.id
        APIService.shared.request(.updateRecommendInfo(info: info))
            .filterSuccessfulStatusCodes()
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(_):
                        self.fetchTargetBook()
                    case .failed(let error):
                        AlertService.shared.alertError(error)
                    default:
                        print(event)
                    }
                }
            }
    }
}

extension GuideMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = recommendedBooks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! GuideRecomendedBookCell
        cell.coverView.setBookCover(item.cover)
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = collectionView.bounds.width
//        let itemHeight = collectionView.bounds.height
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
}

