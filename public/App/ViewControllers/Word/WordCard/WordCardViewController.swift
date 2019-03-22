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
        cardView.backView.memoryButton.text = word.memory
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