//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit
import FolioReaderKit
import ReactiveSwift

fileprivate let MinActulReadRate = 0.7

class BookMainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    // for epub
    // TODO: separate
    var currentBookId: Int?
    var folioReader = FolioReader()
    var currentSentences: [FlipPageSentence]?
    var currentSentence: SelectedSentence?
    var lastPage: Int = 0
    var lastChapter: Int = 0
    var lastTextUpdated: Date = Date()
    var lastUnknown: Date = Date()
    
    
    var dictVC: DictViewController!
    var downloadProgresses: Dictionary<ContentKey, Float> = [:]
    var contents: [Content] = []
    var first: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = .singleLine
        
        self.folioReader.delegate = self
        
        self.tableView.register(BookMainTableViewCell.self, forCellReuseIdentifier: "cell")
        self.reload()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPurchase), name: .didPurchaseBook, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        dictVC = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
    }
 
    func reload() {
        ContentService.shared.getContents().start { event in
            DispatchQueue.main.async{
                switch event {
                case .value(let contents):
                    if !self.first {
                        var new = 0
                        for i in contents {
                            var isNew = true
                            for j in self.contents {
                                if i.key == j.key {
                                    isNew = false
                                    break
                                }
                            }
                            if isNew {
                                new += 1
                            }
                        }
                        if new != 0 {
                            self.navigationController?.tabBarItem.badgeValue = "\(new)"
                        }
                    } else {
                        self.first = false
                    }
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
        super.viewDidAppear(animated)
        navigationController?.tabBarItem.badgeValue = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarItem.badgeValue = nil
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
        currentBookId = content.id
        switch content.type {
        case .sens:
            guard let sens = try? Sens(path: content.path) else {
                AlertService.shared.alertErrorMsg("sens 파싱 에러")
                return
            }
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "SensMainViewController") as! SensMainViewController
            vc.sens = sens
            vc.dictVC = dictVC
            self.present(vc, animated: true)
        case .epub:
            guard let book = try? FREpubParser().readEpub(bookBasePath: content.path) else {
                AlertService.shared.alertErrorMsg("epub 파싱 에러")
                return
            }
            
            let config = FolioReaderConfig()
            config.tintColor = Color.tint
            config.barTintColor = Color.white
            config.barColor = Color.strongGray
            config.canChangeScrollDirection = false
            config.shouldHideNavigationOnTap = false
            config.hideBars = false
            config.enableTTS = false
            config.scrollDirection = .horizontal

            folioReader.presentReader(parentViewController: self, book: book, config: config)
            folioReader.readerCenter!.delegate = self
        }
    }
    
    func updateDownloadProgress(_ key: ContentKey, _ progress: Float) {
        downloadProgresses[key] = progress
        guard let row = contents.index(where: { c in c.key == key }) else {
            return
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookMainTableViewCell else {
            return
        }
        cell.progress = progress
    }

    @objc func didPurchase(notification: NSNotification) {
        reload()
    }
}

extension BookMainViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.contents[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookMainTableViewCell
        
        cell.contentView.layer.masksToBounds = false
        cell.clipsToBounds = false
        cell.name = item.name
        cell.author = item.author
        cell.types[0] = item.type
        cell.setCover(with: item.cover)
        
        switch item {
        case let item as DownloadedContent:
            cell.status = .local
            cell.progress = item.progress
        case is DownloadableContent:
            cell.status = .remote
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
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let content = self.contents[indexPath.row]
        return content is DownloadedContent
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "삭제") { action, index in
            let content = self.contents[indexPath.row] as! DownloadedContent
            do {
                try content.delete()
            } catch {
                AlertService.shared.alertError(GoraniError.system)
            }
            
            self.reload()
        }
        delete.backgroundColor = Color.red
        
        return [delete]
    }
}
