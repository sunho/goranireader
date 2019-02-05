//
//  StoreViewController.swift
//  app
//
//  Created by sunho on 2019/02/03.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class StoreMainViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchHomeVC: SearchHomeViewController!
    var searchResultVC: SearchResultViewController!
    var currentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchHomeVC = storyboard!.instantiateViewController(withIdentifier: "SearchHomeViewController") as? SearchHomeViewController
        searchResultVC = storyboard!.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
        switchVC(searchHomeVC)
    }
    
    func switchVC(_ vc: UIViewController) {
        if currentVC == vc {
            return
        }
        if let prev = currentVC {
            prev.willMove(toParent: nil)
            prev.view.removeFromSuperview()
            prev.removeFromParent()
        }
    
        addChild(vc)
        vc.view.frame = contentView.bounds;
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        currentVC = vc
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchResultVC.isSearching {
            searchResultVC.cancel()
            switchVC(searchHomeVC)
        }
        searchBar.text = nil
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchResultVC.search(text)
            switchVC(searchResultVC)
            searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

}
