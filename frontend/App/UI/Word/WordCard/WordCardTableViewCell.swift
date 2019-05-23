//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class WordCardTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    let space: CGFloat = 8
    
    var examples: [NSAttributedString]!
    var container: PaddingMarginView!
    var definitionView: UILabel!
    var exampleTableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        container = PaddingMarginView()
        container.padding.all = 8
        container.layout()
        container.box.backgroundColor = Color.white
        container.box.borderRadius = .small
        definitionView = UILabel()
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        definitionView = MultilineLabel()
        definitionView.setFont(.small)
        container.addSubview(definitionView)
        
        exampleTableView = SelfSizedTableView()
        exampleTableView.delegate = self
        exampleTableView.dataSource = self
        exampleTableView.register(WordCardExampleTableViewCell.self, forCellReuseIdentifier: "cell")
        exampleTableView.estimatedRowHeight = 50
        exampleTableView.rowHeight = UITableView.automaticDimension
        exampleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        exampleTableView.isScrollEnabled = false
        exampleTableView.backgroundColor = .clear
        container.addSubview(exampleTableView)

        definitionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exampleTableView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.definitionView.preferredMaxLayoutWidth = self.definitionView.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.examples[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WordCardExampleTableViewCell
        cell.sentenceView.attributedText = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.examples.count
    }
    
    func updateLayout(_ detail: Bool) {
        if detail {
            definitionView.snp.remakeConstraints { make in
                make.top.left.right.equalToSuperview()
            }
            
            exampleTableView.snp.remakeConstraints { make in
                make.top.equalTo(definitionView.snp.bottom).offset(space)
                make.bottom.left.right.equalToSuperview()
            }
        } else {
            exampleTableView.snp.remakeConstraints { make in
                make.bottom.left.right.equalToSuperview()
            }
            
            definitionView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func updateState(_ detail: Bool) {
        if detail {
            exampleTableView.alpha = 1
        } else {
            exampleTableView.alpha = 0
        }
    }
}
