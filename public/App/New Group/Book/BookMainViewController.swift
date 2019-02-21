import UIKit
import FolioReaderKit
import SwipeCellKit

fileprivate let MinActulReadRate = 0.7

class BookMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FolioReaderDelegate, FolioReaderCenterDelegate, SwipeTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!

    var dictVC: DictViewController?
    var books: [Epub]!
    var folioReader = FolioReader()
    var currentHTML: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.books = Epub.getLocalBooks()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.folioReader.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.books = Epub.getLocalBooks()
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for cell in tableView.visibleCells {
            UIUtill.dropShadow((cell as! BooksTableCell).back, offset: CGSize(width: 0, height: 3), radius: 4)
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.books = Epub.getLocalBooks()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentDictView(bookName: String, rect: CGRect, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        if let vc = dictVC {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        let vc = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
        vc.word = word
        vc.sentence = sentence
        vc.index = index
        self.folioReader.readerContainer?.view.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.frame = CGRect(x: 20, y: rect.maxY, width: UIScreen.main.bounds.width - 40, height: 300)
        dictVC = vc
    }

    func htmlContentForPage(_ page: FolioReaderPage, htmlContent: String) -> String {
        self.updateKnownWords()
        
        self.currentHTML = htmlContent
        return htmlContent
    }
    
    fileprivate func updateKnownWords() {
        guard let html = self.currentHTML else {
            return
        }
        
        if self.folioReader.readerCenter!.actualReadRate > MinActulReadRate {
            DispatchQueue.global(qos: .default).async {
                try? KnownWord.add(html: html)
            }
        }
    }

    func folioReaderDidClose(_ folioReader: FolioReader) {
        self.currentHTML = nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = FolioReaderConfig()
        config.tintColor = UIUtill.tint
        config.canChangeScrollDirection = false
        config.shouldHideNavigationOnTap = false
        config.hideBars = false
        config.scrollDirection = .horizontal
        
        let book = self.books[indexPath.row]
        
        self.folioReader.presentReader(parentViewController: self, book: book.book!, config: config)
        self.folioReader.readerCenter!.delegate = self
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let book = self.books[indexPath.row]
            try! FileManager.default.removeItem(atPath: book.path)
            self.books = Epub.getLocalBooks()
            self.tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.books[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksTableCell") as! BooksTableCell
        cell.titleLabel.text = item.title
        cell.coverImage.image = item.cover
        
        UIUtill.dropShadow(cell.back, offset: CGSize(width: 0, height: 3), radius: 4)
        cell.contentView.layer.masksToBounds = false
        cell.clipsToBounds = false
        
        cell.delegate = self

        return cell
    }
}
