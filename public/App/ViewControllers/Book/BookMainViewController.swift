import UIKit
import FolioReaderKit
import SwipeCellKit
import ReactiveSwift

fileprivate let MinActulReadRate = 0.7

class BookMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    // for epub
    // TODO: separate
    var currentBookId: Int?
    var folioReader = FolioReader()
    var currentHTML: String?
    
    
    var dictVC: DictViewController!
    var downloadProgresses: Dictionary<ContentKey, Float> = [:]
    var contents: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        self.folioReader.delegate = self
        
        self.tableView.register(BookListTableViewCell.self, forCellReuseIdentifier: "cell")
        self.reload()
        
        dictVC = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
    }
 
    func reload() {
        ContentService.shared.getContents().start { event in
            DispatchQueue.main.async{
                switch event {
                case .value(let contents):
                    self.contents = contents
                    self.tableView.reloadData()
                default:
                    print(event)
                }
            }
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.reload()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func downloadContent(_ content: DownloadableContent) {
        if downloadProgresses[content.key] == nil {
            ContentService.shared.downloadContent(content)
                .start { event -> Void in
                    DispatchQueue.main.async{
                        switch event {
                        case .completed:
                            self.downloadProgresses.removeValue(forKey: content.key)
                            self.reload()
                        case .value(let progress):
                            self.updateDownloadProgress(content.key, progress)
                        default:
                            self.downloadProgresses.removeValue(forKey: content.key)
                            print(event)
                        }
                    }
            }
        }
    }
    
    func openContent(_ content: DownloadedContent) {
        switch content.type {
        case .sens:
            guard let sens = try? Sens(path: content.path) else {
                return
            }
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "SensMainViewController") as! SensMainViewController
            vc.sens = sens
            vc.dictVC = dictVC
            self.present(vc, animated: true)
        case .epub:
            print("adsfas")
        }
    }
    
    func updateDownloadProgress(_ key: ContentKey, _ progress: Float) {
        downloadProgresses[key] = progress
        guard let row = contents.index(where: { c in c.id == key.id }) else {
            return
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookListTableViewCell else {
            return
        }
        cell.progress = progress
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
        cell.name = item.name
        cell.author = item.author
        cell.type = item.type
        cell.setCover(with: item.cover)
        
        switch item {
        case let item as DownloadedContent:
            cell.tableType = .local
            cell.progress = item.progress
        case is DownloadableContent:
            cell.tableType = .download
        default:
            fatalError("?")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = contents[indexPath.row]
        if let item = item as? DownloadableContent {
            downloadContent(item)
        }
        
        if let item = item as? DownloadedContent {
            openContent(item)
        }
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
    

}
