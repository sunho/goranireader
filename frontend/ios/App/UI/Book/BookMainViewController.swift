//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

fileprivate let MinActulReadRate = 0.7

class BookMainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var dictVC: DictViewController!
    var downloadProgresses: Dictionary<String, Float> = [:]
    var contents: [Content] = []
    var first: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 160
        self.tableView.separatorStyle = .singleLine
    
        self.tableView.register(BookMainTableViewCell.self, forCellReuseIdentifier: "cell")
        self.reload()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPurchase), name: .didPurchaseBook, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        dictVC = storyboard!.instantiateViewController(withIdentifier: "DictViewController") as! DictViewController
    }
 
    func reload() {
        ContentService.shared.getContents().then { contents in
            print(contents)
            DispatchQueue.main.async{
                if !self.first {
                    var new = 0
                    for i in contents {
                        var isNew = true
                        for j in self.contents {
                            if i.id == j.id {
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
            }
        }.catch { error in
            fatalError(error.localizedDescription)
        }
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        self.reload()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        navigationController?.tabBarItem.badgeValue = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.tabBarItem.badgeValue = nil
    }
    
    func downloadContent(_ content: DownloadableContent) {
        if downloadProgresses[content.id] == nil {
            downloadProgresses[content.id] = 0
            ContentService.shared.downloadContent(content).then { _ in
                self.reload()
                self.downloadProgresses.removeValue(forKey: content.id)
            }.catch { _ in
                self.downloadProgresses.removeValue(forKey: content.id)
            }
        }
    }
    
    func updateDownloadProgress(_ key: String, _ progress: Float) {
        downloadProgresses[key] = progress
        guard let row = contents.index(where: { c in c.id == key }) else {
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
        cell.types = [.epub]
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
    
    func openContent(_ content: DownloadedContent) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "BookReaderViewController") as! BookReaderViewController
        vc.book = try! BookyBook.fromPath(path: content.path)
        navigationController?.pushViewController(vc, animated: true)
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
