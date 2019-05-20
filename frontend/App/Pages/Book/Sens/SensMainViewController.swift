//
//  SensMainViewController.swift
//  app
//
//  Created by sunho on 2019/03/19.
//  Copyright © 2019 sunho. All rights reserved.
//

// TODO REFACTOR

import UIKit

fileprivate struct State {
    var evaluated: Bool = false
    var answers: [Int] = []
    var backs: Set<Int> = Set() // back used page
}

fileprivate enum ScrollDirection {
    case none
    case left
    case right
}

class SensMainViewController: UIViewController, UITextViewDelegate, DictViewControllerDelegate {
    fileprivate var state: State = State()
    fileprivate var scrollDirection: ScrollDirection = .none
    
    fileprivate var submitScreen: SwipeSubmitScreen!
    
    var sens: Sens!
    var dictVC: DictViewController!
    var currentPage: Int = 0
    var currentSentence: SensSentence {
        return sens.sentences[currentPage]
    }
    var totalPage: Int = 0
    
    var subPage: Int {
        return currentPage % 5
    }
    var hasEnoughAnswers: Bool {
        return currentSentence.answers.count == 3
    }
    var canProgress: Bool {
        return state.answers.count > subPage
    }
    var willDamage: Bool {
        return !state.backs.contains(subPage) && subPage != 0
    }
    var totalSubPage: Int {
        if currentPage > totalPage / 5 * 5 {
            return totalPage % 5
        }
        return 5
    }
    var subRange: Range<Int> {
        return (Int(currentPage / 5) * 5)..<(Int(currentPage / 5) * 5 + totalSubPage)
    }
    var subSentences: [SensSentence] {
        return Array(sens.sentences[subRange])
    }

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let collectionViewLayout = HorizontalPageLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictVC.addViewToWindow()
        
        state = getStateFromRealm()
        totalPage = sens.sentences.count
    
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    
        collectionViewLayout.sectionInset = UIEdgeInsets.zero
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.register(SensCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = true
        
        submitScreen = SwipeSubmitScreen(frame: collectionView.bounds)
        view.addSubview(submitScreen)
        submitScreen.snp.makeConstraints { make in
            make.edges.equalTo(collectionView.snp.edges)
        }
       
        submitScreen.delegate = self

        tableView.register(RoundOptionCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        reloadData()
        
        collectionView.addGestureRecognizer(submitScreen.recognizer)
        
        pageControl.numberOfPages = 5
        pageControl.isUserInteractionEnabled = false
    }
    
    func stateUpdated() {
        let subs = subSentences
        for i in 0..<state.answers.count {
            let res = RealmService.shared.getSensResult(bookId: sens.bookId, sensId: subs[i].id)
            RealmService.shared.write {
                res.answer = state.answers[i]
            }
        }
    }
    
    fileprivate func getStateFromRealm() -> State {
        let subs = subSentences
        var out = State()
        out.evaluated = true
        for i in 0..<subs.count {
            let res = RealmService.shared.getSensResult(bookId: sens.bookId, sensId: subs[i].id)
            if res.answer == -1 && subs[i].answers.count == 3 {
                out.evaluated = false
                break
            }
            if res.back && i != 0 {
                out.backs.insert(i)
            }
            out.answers.append(res.answer)
        }
        return out
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dictVC.addViewToWindow()
        dictVC.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dictVC.removeViewFromWindow()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let range = textView.selectedTextRange else {
            dictVC.hide()
            return
        }
        
        if let text = textView.text(in: range) {
            let rect = textView.caretRect(for: range.start)
            let point = CGPoint(x: rect.minX, y: rect.minY)
            // TODO
            dictVC.show(point, UnknownDefinitionTuple(text, sens.bookId, "", 0))
        }
    }
    
    func dictViewControllerDidSelect(_ dictViewController: DictViewController, _ tuple: UnknownDefinitionTuple, _ word: DictEntry, _ def: DictDefinition) {
         RealmService.shared.putUnknownWord(word, def, tuple)
    }
    
    @IBAction func openChapterList(_ sender: Any) {
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SensMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation: CGPoint = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.x < 0 {
            scrollDirection = .right
        } else if translation.x > 0 {
            scrollDirection = .left
        }
        
        // prevent scroll when the use didn't select the answer or submit the answers
        if scrollDirection == .right &&
            (hasEnoughAnswers && !canProgress || !state.evaluated && subPage == totalSubPage - 1) {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        // enable submit screen
        if !state.evaluated && subPage == totalSubPage - 1 {
            submitScreen.recognizer.isEnabled = true
        } else {
            submitScreen.recognizer.isEnabled = false
        }
        
        // update currentPage
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        let oldPage = currentPage
        currentPage = indexPath.item
        
        if oldPage != currentPage {
            updateState()
        }
    }
    
    func updateState() {
        dictVC.hide()
        if scrollDirection == .right {
            if subPage == 0 {
                state = getStateFromRealm()
            }
            if !hasEnoughAnswers && state.answers.count <= subPage {
                state.answers.append(-1)
            }
        }
        if scrollDirection == .left {
            if subPage == totalSubPage - 1 {
                state = getStateFromRealm()
            } else {
                state.backs.insert(subPage + 1)
            }
        }
        stateUpdated()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = subPage
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
        DispatchQueue.main.async {
            if self.canProgress && self.hasEnoughAnswers {
                let indexPath = IndexPath(row: self.state.answers[self.subPage], section: 0)
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                self.tableView.cellForRow(at: indexPath)?.layoutIfNeeded()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sens.sentences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! SensCollectionViewCell
        cell.textView.text = self.sens.sentences[indexPath.item].text
        cell.textView.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension SensMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
        if !hasEnoughAnswers {
            return
        }
        if  (!canProgress) {
            state.answers.append(indexPath.row)
        } else {
            state.answers[subPage] = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RoundOptionCell
        if !hasEnoughAnswers {
            cell.isOpaque = true
            return cell
        }
        
        let answer = currentSentence.answers[indexPath.row]
        cell.isOpaque = false
        cell.indexView.text = "\(indexPath.row)"
        cell.textView.text = answer
        return cell
    }
}

extension SensMainViewController: SwipeSubmitScreenDelegate {
    func swipeSubmitted() {
        state.evaluated = true
    }
}
