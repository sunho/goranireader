//
//  WordCardTableViewCell.swift
//  app
//
//  Created by sunho on 2019/03/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

class WordCardTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    var examples: [String]!
    var container: PaddingMarginView!
    var definitionView: UILabel!
    var exampleTableView: UITableView!
    
    var isDetail: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        container = PaddingMarginView()
        container.padding.all = 4
        definitionView = UILabel()
        addSubview(definitionView)
        definitionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        definitionView.setFont(.normal)
        
        exampleTableView = SelfSizedTableView()
        addSubview(exampleTableView)
        exampleTableView.snp.makeConstraints { make in
            make.top.equalTo(definitionView.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        exampleTableView.isHidden = true
        exampleTableView.delegate = self
        exampleTableView.dataSource = self
        exampleTableView.register(WordCardExampleTableViewCell.self, forCellReuseIdentifier: "cell")
        exampleTableView.rowHeight = UITableView.automaticDimension
        exampleTableView.estimatedRowHeight = 50
        exampleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        exampleTableView.isScrollEnabled = false
        exampleTableView.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.examples[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WordCardExampleTableViewCell
        
        cell.sentenceView.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.examples.count
    }
    
    func updateState() {
        
    }
}
