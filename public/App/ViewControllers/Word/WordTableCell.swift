import UIKit

class WordTableCell: UITableViewCell {
    @IBOutlet weak var back: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet var quizIcons: [UIButton]!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
}
