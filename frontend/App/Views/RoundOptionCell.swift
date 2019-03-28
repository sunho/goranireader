import UIKit

class RoundOptionCell: UITableViewCell {
    fileprivate var container: PaddingMarginView!
    var indexView: UILabel!
    var textView: UILabel!
    
    var normalColor: UIColor = Color.white {
        didSet {
            container.box.backgroundColor = normalColor
        }
    }
    var hoverColor: UIColor = Color.darkGray
    var selectColor: UIColor = Color.tint
    
    override var isOpaque: Bool {
        didSet {
            container.isHidden = isOpaque
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        container = PaddingMarginView()
        container.padding.top = 12
        container.padding.bottom = 12
        container.margin.top = 4
        container.margin.left = 8
        container.margin.right = 8
        container.margin.bottom = 4
        container.layout()
        
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indexView = UILabel()
        container.addSubview(indexView)
        indexView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        indexView.setFont()
        container.box.backgroundColor = normalColor
        container.box.borderRadius = .small
        
        textView = MultilineLabel()
        textView.text = " "
        textView.setFont()
        container.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(indexView.snp.right).offset(10)
        }
        
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.textView.preferredMaxLayoutWidth = self.textView.frame.size.width
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        container.box.backgroundColor = highlighted ? hoverColor : normalColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        container.box.backgroundColor = selected ? selectColor : normalColor
    }
}
