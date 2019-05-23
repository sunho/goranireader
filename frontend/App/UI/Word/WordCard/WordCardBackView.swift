//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import UIKit

class WordCardBackView: UIView {
    var container: PaddingMarginView!
    var wordView: UILabel!
    var tableView: UITableView!
    var memoryButton: MemoryButton!
    var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container = PaddingMarginView()
        container.margin.all = 20
        container.layout()
        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clipsToBounds = true
        backgroundColor = Color.gray
        borderRadius = .small
        
        wordView = UILabel()
        container.addSubview(wordView)
        wordView.setFont(.medium, Color.strongGray, .medium)
        wordView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        detailButton = UIButton()
        container.addSubview(detailButton)
        detailButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0.01, right: 0)
        detailButton.snp.makeConstraints { make in
            make.centerY.equalTo(wordView.snp.centerY)
            make.left.equalTo(wordView.snp.right)
            make.right.equalToSuperview()
        }
        detailButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        detailButton.setTitleColor(Color.tint, for: .normal)
        detailButton.setTitle("상세", for: .normal)
        
        tableView = UITableView()
        container.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(wordView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        memoryButton = MemoryButton(frame: CGRect())
        container.addSubview(memoryButton)
        memoryButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func updateState(_ detail: Bool) {
        if detail {
            tableView.isScrollEnabled = true
            wordView.setFont(.big, Color.strongGray, .medium)
        } else {
            tableView.isScrollEnabled = false
            wordView.setFont(.medium, Color.strongGray, .medium)
        }
        
        for row in tableView.visibleCells {
            let row = row as! WordCardTableViewCell
            row.updateState(detail)
        }
        memoryButton.updateState(detail)
    }
    
    func updateLayout(_ detail: Bool) {
        for row in tableView.visibleCells {
            let row = row as! WordCardTableViewCell
            row.updateLayout(detail)
        }
        memoryButton.updateLayout(detail)
    }
    
    func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
