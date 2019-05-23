import UIKit

fileprivate let MaxChar = 120
fileprivate let height: CGFloat = 200
fileprivate let padding: CGFloat = 0

protocol DictViewControllerDelegate {
    func dictViewControllerDidSelect(_ dictViewController: DictViewController, _ tuple: UnknownDefinitionTuple, _ word: DictEntry, _ def: DictDefinition)
}

class DictViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var wordView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    fileprivate var hidden: Bool = true
    fileprivate var tuple: UnknownDefinitionTuple?

    fileprivate let topY: CGFloat = 0
    fileprivate let topHiddenY = -height
    fileprivate let bottomY = UIScreen.main.bounds.height - height
    fileprivate let bottomHiddenY = UIScreen.main.bounds.height
    
    var delegate: DictViewControllerDelegate?
    
    var entries: [DictEntry]?
    var currentEntry: Int = 0
    
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
        
        tableView.register(RoundOptionCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func show(_ point: CGPoint, _ tuple: UnknownDefinitionTuple) {
        self.tuple = tuple
        let entries = DictService.shared.search(word: tuple.word)
        if entries.count == 0 {
            return
        }
    
        self.entries = entries
        currentEntry = 0
        reloadData()
    
        let centerY = UIScreen.main.bounds.height/2
        var oldy: CGFloat = 0
        var newy: CGFloat = 0
        print(point)
        if point.y  < centerY {
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
        if let entries = entries {
            nextButton.isEnabled = true
            prevButton.isEnabled = true
            if currentEntry == entries.count - 1 {
                nextButton.isEnabled = false
            }
            if currentEntry == 0 {
                prevButton.isEnabled = false
            }
            wordView.text = entries[currentEntry].word ?? ""
            tableView.reloadData()
        }
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
        if entries == nil {
            return 0
        }
        return self.entries![currentEntry].defs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.entries![currentEntry].defs[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoundOptionCell
        cell.normalColor = Color.white
        cell.indexView.text = "\(indexPath.row + 1)"
        cell.textView.text = item.def
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.dictViewControllerDidSelect(self, tuple!, entries![currentEntry], entries![currentEntry].defs[indexPath.row])
        hide()
    }
    
    @IBAction func prev(_ sender: Any) {
        currentEntry -= 1
        reloadData()
    }
    
    @IBAction func next(_ sender: Any) {
        currentEntry += 1
        reloadData()
    }
}
