//
//  RecommendMainViewController.swift
//  app
//
//  Created by sunho on 2019/02/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import Moya

struct GuideCardProvider {
    var name: String
    var cellType: AnyClass?
    var count: () -> Int
}

class GuideMainViewController: UIViewController {
    @IBOutlet weak var progressView: GuideProgressView!
    @IBOutlet weak var wordCardView: GuideWordCardView!
    @IBOutlet weak var bookView: GuideRecommendedBookView!
    
    var recommendedBooks: [(RecommendedBook, Book)] = []
    var wordCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        bookView.collectionView.delegate = self
        bookView.collectionView.dataSource = self
        bookView.collectionView.register(GuideRecomendedBookCell.self, forCellWithReuseIdentifier: "cell")
        wordCount = RealmService.shared.getTodayUnknownWords().count
        ReachabilityService.shared.reach.producer.start { [weak self] _ in
            self?.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(unknownWordAdded), name: .unknownWordAdded, object: nil)
    }
    
    func reloadData() {
        APIService.shared.request(.getTargetBookProgress)
            .handle(ignoreError: true, type: TargetBookProgress.self) { offline, progress in
                if !offline {
                    self.progressView.progressBar.progress = Float(progress!.progress)
                }
            }
        
        APIService.shared.request(.listRecommendedBooks)
            .mapPlain([RecommendedBook].self)
            .flatMap(.latest) { raws -> SignalProducer<[(RecommendedBook, Book)], MoyaError> in
                let arr = raws.map { raw in
                    return APIService.shared.request(.getShopBook(bookId: raw.bookId))
                        .filterSuccessfulStatusCodes()
                        .mapPlain(Book.self)
                        .map { book in
                            return (raw, book)
                        }
                }
                return SignalProducer<SignalProducer<(RecommendedBook, Book), MoyaError>, MoyaError>(arr).flatten(.concat).reduce([]) { $0 + [$1] }
            }.handlePlain(ignoreError: false) { (offline, books) in
                if !offline {
                    self.recommendedBooks = books!
                    self.layout()
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
    
    func layout() {
        if wordCount == 0 {
            wordCardView.button.isEnabled = false
            wordCardView.textView.text = "복습해야 할 단어가 없습니다"
        } else {
            wordCardView.button.isEnabled = true
            wordCardView.textView.text = "총 \(wordCount)개의 단어를 복습해야 합니다"
        }
        
        bookView.collectionView.reloadData()
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
            .handle(ignoreError: false)
    }
}

extension GuideMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = recommendedBooks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! GuideRecomendedBookCell
        cell.coverView.setBookCover(item.1.cover)
        cell.heart = item.0.rate == 1
        cell.heartButton.addTarget(self, action: #selector(toggleHeart(sender:)), for: .touchUpInside)
        cell.closeButton.addTarget(self, action: #selector(closeBook(sender:)), for: .touchUpInside)
        cell.closeButton.tag = indexPath.item
        return cell
    }
    
    @objc func toggleHeart(sender: UIButton) {
        let cell = bookView.collectionView.visibleCells[sender.tag] as! GuideRecomendedBookCell
        let item = recommendedBooks[sender.tag]
        if cell.heart {
            cell.heart = false
            APIService.shared.request(.rateRecommendedBook(bookId: item.0.bookId, rate: 0))
                .handle(ignoreError: false)
        } else {
            cell.heart = true
            APIService.shared.request(.rateRecommendedBook(bookId: item.0.bookId, rate: 1))
                .handle(ignoreError: false)
        }
    }
    
    @objc func closeBook(sender: UIButton) {
        let item = recommendedBooks[sender.tag]
        APIService.shared.request(.rateRecommendedBook(bookId: item.0.bookId, rate: -1))
            .handle(ignoreError: false)
        APIService.shared.request(.deleteRecommendedBook(bookId: item.0.bookId))
            .handle(ignoreError: false) { offline, _ in
                if !offline {
                    self.recommendedBooks.remove(at: sender.tag)
                    self.layout()
                }
            }
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = collectionView.bounds.width
//        let itemHeight = collectionView.bounds.height
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
}

