import UIKit
import FolioReaderKit
import SwipeCellKit

fileprivate let MinActulReadRate = 0.7

class BookMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FolioReaderDelegate, FolioReaderCenterDelegate, SwipeTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!

    var dictVC: DictViewController?
    var contents: [Content] = []
    var folioReader = FolioReader()
    var currentHTML: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContentService.shared.getDownloadableContents().start { event in
            switch event {
            case .value(let contents):
                print(contents)
                self.contents = contents
            default:
                print(event)
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.folioReader.delegate = self
        
        self.tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.tableView.reloadData()
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func removeDictView() {
        if let vc = dictVC {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            dictVC = nil
        }
    }
    
    func presentDictView(bookName: String, rect: CGRect, page: Int, scroll: CGFloat, sentence: String, word: String, index: Int) {
        removeDictView()
        let vc = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
        vc.word = word
        vc.sentence = sentence
        vc.index = index
        self.folioReader.readerContainer?.view.addSubview(vc.view)
        vc.didMove(toParent: self.folioReader.readerContainer)
        vc.view.frame = CGRect(x: 20, y: rect.maxY, width: UIScreen.main.bounds.width - 40, height: 300)
        dictVC = vc
    }
    
    func hideDictView() {
        removeDictView()
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
                //try? KnownWord.add(html: html)
            }
        }
    }

    func folioReaderDidClose(_ folioReader: FolioReader) {
        self.currentHTML = nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let config = FolioReaderConfig()
//        config.tintColor = UIUtill.tint
//        config.canChangeScrollDirection = false
//        config.shouldHideNavigationOnTap = false
//        config.hideBars = false
//        config.scrollDirection = .horizontal
//
//        let book = self.contents[indexPath.row]
//
//        self.folioReader.presentReader(parentViewController: self, book: book.book!, config: config)
//        self.folioReader.readerCenter!.delegate = self
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            let book = self.contents[indexPath.row]
//            try! FileManager.default.removeItem(atPath: book.path)
//            self.books = Epub.getLocalBooks()
//            self.tableView.reloadData()
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
//
        return []
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.contents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookListTableViewCell
        
        cell.contentView.layer.masksToBounds = false
        cell.clipsToBounds = false

        return cell
    }
}
