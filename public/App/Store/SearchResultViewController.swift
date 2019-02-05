//
//  SearchResultViewController.swift
//  app
//
//  Created by sunho on 2019/02/05.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func search(_ keyword: String) {
        isSearching = true
    }
    
    func cancel() {
        isSearching = false
    }
}
