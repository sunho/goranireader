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
    func didFlip()
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
        cardView.wordView.text = "asdf"
        cardView.backView.wordView.text = "asdf"
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
            delegate?.didFlip()
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
        frontView.backgroundColor = UIUtill.gray
        frontView.borderRadius = .small
        frontView.isHidden = false
        
        wordView = UILabel()
        wordView.setFont(.big, .black, .bold)
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
    var wordView: UILabel!
    var tableView: UITableView!
    var memoryView: UILabel!
    var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = UIUtill.gray
        borderRadius = .small
        
        wordView = UILabel()
        addSubview(wordView)
        wordView.setFont()
        wordView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        }
        
        detailButton = UIButton()
        addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(wordView.snp.right)
            make.width.equalTo(50)
            make.right.equalToSuperview().offset(20)
        }
        
        tableView = UITableView()
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(wordView.snp.bottom)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20))
        }
        
        memoryView = UILabel()
        addSubview(memoryView)
        memoryView.setFont()
        memoryView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
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
