//
//  WordCardView.swift
//  app
//
//  Created by sunho on 2019/03/21.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

protocol WordCardViewControllerDelegate {
    func wordCardViewDidFlip()
    func wordCardViewDidOpenDetail()
    func wordCardViewDidHideDetail()
}

class WordCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var frame: CGRect!
    var word: UnknownWord!
    var delegate: WordCardViewControllerDelegate?
    var cardView: WordCardView {
        return view as! WordCardView
    }
    fileprivate var opened: Bool = false
    
    init(frame: CGRect) {
        super.init(nibName:nil, bundle:nil)
        self.frame = frame
    }
    
    override func loadView() {
        view = WordCardView(frame: frame)
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cardView.addGestureRecognizer(tap)
        cardView.wordView.text = word.word
        cardView.backView.wordView.text = word.word
        cardView.backView.memoryView.text = word.memory
        cardView.backView.tableView.delegate = self
        cardView.backView.tableView.dataSource = self
        cardView.backView.tableView.register(WordCardTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if !opened {
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
            UIView.transition(from: cardView.frontView, to: cardView.backView, duration: 0.5, options: transitionOptions) { _ in
                self.cardView.backView.isHidden = false
                self.cardView.frontView.isHidden = true
            }
            opened = true
            delegate?.wordCardViewDidFlip()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.word.definitions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WordCardTableViewCell
        
        cell.examples = item.examples.map { i -> String in
            return i.sentence
        }
        cell.definitionView.text = item.definition
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.word.definitions.count
    }
}

class WordCardView: CardView {
    var frontView: UIView!
    var backView: WordCardBackView!
    var wordView: UILabel!
    var opened: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        frontView = UIView()
        contentView.addSubview(frontView)
        frontView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        frontView.clipsToBounds = true
        frontView.backgroundColor = UIUtill.tint
        frontView.borderRadius = .small
        frontView.isHidden = false
        
        wordView = UILabel()
        wordView.setFont(.big, UIUtill.white, .bold)
        frontView.addSubview(wordView)
        wordView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        backView = WordCardBackView(frame: frame)
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}

class WordCardBackView: UIView {
    var container: PaddingMarginView!
    var wordView: UILabel!
    var tableView: UITableView!
    var memoryView: UILabel!
    var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container = PaddingMarginView()
        container.margin.all = 20
        container.layout()
        addSubview(container)
        
        clipsToBounds = true
        backgroundColor = UIUtill.gray
        borderRadius = .small
        
        wordView = UILabel()
        container.addSubview(wordView)
        wordView.setFont(.medium, UIUtill.strongGray, .medium)
        wordView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        detailButton = UIButton()
        container.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(wordView.snp.right)
            make.width.equalTo(50)
            make.right.equalToSuperview().offset(20)
        }
        
        tableView = UITableView()
        container.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(wordView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        
        memoryView = UILabel()
        container.addSubview(memoryView)
        memoryView.setFont()
        memoryView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
