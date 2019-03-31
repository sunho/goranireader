//
//  SearchResultViewController.swift
//  app
//
//  Created by sunho on 2019/02/05.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import ReactiveSwift
import FolioReaderKit
import ReactiveMoya
import Moya
import Kingfisher

protocol SearchResultViewControllerDelegate {
    func searchResultViewControllerDidSelect(_ viewController: SearchResultViewController, _ book: Book, _ owned: Bool)
}

class SearchResultViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var keyword: String = ""
    var isSearching: Bool = false
    var isFetching: Bool = false
    var reachEnd: Bool = false
    var books: [Book] = []
    var ownBooks: [Book] = []
    var p: Int = 0
    var delegate: SearchResultViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.register(BookShopTableViewCell.self, forCellReuseIdentifier: "cell")
        
        updateOwnBooks()
    }
    
    func updateOwnBooks() {
        APIService.shared.request(.listBooks)
            .filterSuccessfulStatusCodes()
            .map([Book].self)
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let books):
                        self.ownBooks = books
                    default:
                        print(event)
                    }
                }
            }
    }
    
    func search(_ keyword: String) {
        books = []
        tableView.reloadData()
        isSearching = true
        isFetching = false
        reachEnd = false
        p = 0
        self.keyword = keyword
        fetch()
    }
    
    func fetch() {
        if !isFetching && !reachEnd {
            isFetching = true
            let currentKeyword = keyword
            let currentP = p
            APIService.shared.request(.searchShopBooks(name: keyword, p: p + 1, orderBy: "name desc"))
                .filterSuccessfulStatusCodes()
                .map([Book].self)
                .start { event in
                    self.observer(event, currentKeyword, currentP)
                }
        }
    }
        
    fileprivate func observer(_ event: Signal<[Book], MoyaError>.Event, _ oldKeyword: String, _ oldP: Int) {
        if self.keyword != oldKeyword || self.p != oldP {
            return
        }
        DispatchQueue.main.async {
            switch event {
            case .value(let books):
                self.books.append(contentsOf: books)
                self.p += 1
                self.reload()
            case .failed(let error):
                if let resp = error.response {
                    if resp.statusCode == 404 {
                        self.reachEnd = true
                    }
                    break
                }
                AlertService.shared.alertError(error)
            default:
                print(event)
            }
            self.isFetching = false
        }
    }
    
    func reload() {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    func cancel() {
        isSearching = false
        self.books = []
        tableView.reloadData()
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.books[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookShopTableViewCell
        cell.name = item.name
        cell.author = item.author
        cell.types = item.types
        
        if let cover = URL(string: item.cover) {
            cell.setCover(with: Source.network(ImageResource(downloadURL: cover)))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.books[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let owned = ownBooks.filter({b in b.id == item.id}).count != 0
        delegate?.searchResultViewControllerDidSelect(self, item, owned)
    }
}

