//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

protocol StoreMainViewControllerDelegate {
    func title() -> String
    func storeMainViewControllerDidSelect(_ viewController: StoreMainViewController, _ book: Book)
}

class StoreMainViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, SearchResultViewControllerDelegate {
    @IBOutlet weak var contentView: UIView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchHomeVC: SearchHomeViewController!
    var searchResultVC: SearchResultViewController!
    var currentVC: UIViewController?
    var delegate: StoreMainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchHomeVC = storyboard!.instantiateViewController(withIdentifier: "SearchHomeViewController") as? SearchHomeViewController
        searchResultVC = storyboard!.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
        searchResultVC.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.tintColor = Color.white
        modalPresentationStyle = .overFullScreen
        if let delegate = delegate {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.title = delegate.title()
        }
        
        if let textfield =  searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = Color.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
        switchVC(searchHomeVC)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            switchVC(searchResultVC)
            searchResultVC.search(text)
            searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchResultViewControllerDidSelect(_ viewController: SearchResultViewController, _ book: Book) {
        if let delegate = delegate {
            delegate.storeMainViewControllerDidSelect(self, book)
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreBookDetailViewController") as! StoreBookDetailViewController
        vc.book = book
        navigationController?.pushViewController(vc, animated: true)
    }
}
