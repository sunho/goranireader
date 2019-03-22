import UIKit

fileprivate let MaxChar = 120
fileprivate let height: CGFloat = 200
fileprivate let padding: CGFloat = 0

class DictViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wordView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var hidden: Bool = true
    fileprivate var word: String = ""
    fileprivate var sentence: String = ""
    fileprivate var index: Int = 0

    
    fileprivate let topY: CGFloat = 0
    fileprivate let topHiddenY = -height
    fileprivate let bottomY = UIScreen.main.bounds.height - height
    fileprivate let bottomHiddenY = UIScreen.main.bounds.height
    
    var entry: DictEntry!
    
    func addViewToWindow() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(view)
    }
    
    func removeViewFromWindow() {
        view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
    }
    
    func show(_ point: CGPoint, word: String, sentence: String, index: Int, bookId: Int) {
        let entries = DictService.shared.search(word: word)
        if entries.count == 0 {
            return
        }
    
        entry = entries[0]
        reloadData()
    
        let centerY = UIScreen.main.bounds.height/2 - height / 2
        var oldy: CGFloat = 0
        var newy: CGFloat = 0
        if point.y  < centerY - 100 {
            // bottom
            oldy = bottomHiddenY
            newy = bottomY
        } else {
            oldy = topHiddenY
            newy = topY
        }
    
        view.isHidden = false
        view.frame = CGRect(x: padding, y: oldy, width: UIScreen.main.bounds.width - padding * 2, height: height)
        if hidden {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.frame.origin.y = newy
            }, completion: nil)
            hidden = false
        } else {
            view.frame.origin.y = newy
        }
    }
    
    func reloadData() {
        wordView.text = entry.word
        tableView.reloadData()
    }
    
    func hide() {
        if !hidden {
            var newy: CGFloat = 0
            if self.view.frame.origin.y == topY {
                newy = topHiddenY
            } else {
                newy = bottomHiddenY
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.frame.origin.y = newy
            }, completion: nil)
            hidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entry.defs.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let entry = self.entries[indexPath.section].defs[indexPath.row]
        
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: kDictViewTableCell, for: indexPath) as! DictViewTableCell
//        cell.backgroundColor = UIColor.clear
//        cell.label.text = entry.def
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
    }
}
