//
//  SearchResultViewController.swift
//  app
//
//  Created by sunho on 2019/02/05.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import FolioReaderKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var isSearching: Bool = false
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func search(_ keyword: String) {
        isSearching = true
        API.shared.getBooks(success: { (books) in
            self.books = books
            self.tableView.reloadData()
        },failure:{(err) in })
    }
    
    func cancel() {
        isSearching = false
        self.books = []
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for cell in tableView.visibleCells {
            UIUtill.dropShadow((cell as! BooksTableCell).back, offset: CGSize(width: 0, height: 3), radius: 4)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = self.books[indexPath.row]
        let localUrl = FileManager.default.temporaryDirectory.appendingPathComponent("download"+String(book.id)+String(NSDate().timeIntervalSince1970)+".epub")
        print("Asdf")
        Downloader.load(url: URL(string: book.epub)!, to: localUrl, completion: {
            let asdf = try! FREpubParser().readEpub(epubPath: localUrl.path, removeEpub: false, unzipPath: FileUtill.booksDir.path)
            print(asdf)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.books[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableCell") as! BooksTableCell
        cell.titleLabel.text = item.name
        cell.coverImage.downloaded(from: item.img)
        
        UIUtill.dropShadow(cell.back, offset: CGSize(width: 0, height: 3), radius: 4)
        cell.contentView.layer.masksToBounds = false
        cell.clipsToBounds = false
        
        return cell
    }
}
