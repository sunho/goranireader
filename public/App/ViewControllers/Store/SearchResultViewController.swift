//
//  SearchResultViewController.swift
//  app
//
//  Created by sunho on 2019/02/05.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit
import FolioReaderKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var isSearching: Bool = false
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func search(_ keyword: String) {
        isSearching = true
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
}
