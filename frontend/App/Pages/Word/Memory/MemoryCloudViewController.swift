//
//  MemoryCloudViewController.swift
//  app
//
//  Created by sunho on 2019/03/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

fileprivate let padding = 20

class MemoryCloudViewController: UIViewController {
    var clouds: [MemoryCloudCell] = []
    var word: String!
    var frame: CGRect!
    var hidden: Bool = true

    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    func addViewToWindow() {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(view)
    }
    
    func removeViewFromWindow() {
        view.removeFromSuperview()
    }
    
    func addSentenceCloud(id: Int, sentence: String, rate: Int) {
        let cloud = MemoryCloudCell(type: .sentence)
        cloud.id = id
        cloud.textView.text = sentence
        clouds.append(cloud)
    }
    
    func show(frame: CGRect, word: String) {
        clearData()
        if hidden {
            addViewToWindow()
            hidden = false
        }
        view.frame = frame
        view.isHidden = false
        view.layoutIfNeeded()
        let window = UIApplication.shared.keyWindow!
        window.bringSubviewToFront(view)
        print(view.frame)
        
        APIService.shared.request(.listMemories(word: word, p: 0))
            .map([Memory].self)
            .start { event in
                DispatchQueue.main.async {
                    switch event {
                    case .value(let memories):
                        for memory in memories {
                            self.addSentenceCloud(id: memory.id ?? -1, sentence: memory.sentence, rate: Int(memory.rate ?? 0))
                        }
                    case .failed(let error):
                        AlertService.shared.alertError(error)
                    default:
                        print(event)
                    }
                    self.reloadData()
                }
            }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.alpha = 1
        }, completion: nil)
    }
    
    func clearData() {
        for cloud in clouds {
            cloud.removeFromSuperview()
        }
        clouds = []
    }
    
    func reloadData() {
        for cloud in clouds {
            cloud.removeFromSuperview()
        }
        
        var xAxis = padding
        var yAxis = padding
        var maxHeight = 0
        
        for (index, cloud) in clouds.enumerated() {
            if index == 0 {
                maxHeight = Int(cloud.frame.height)
            }else{
                let expectedWidth = xAxis + Int(cloud.frame.width) + padding
                
                if expectedWidth > Int(frame.width) {
                    yAxis += maxHeight + padding
                    xAxis = padding
                    maxHeight = Int(cloud.frame.height)
                }
                
                if Int(cloud.frame.height) > maxHeight {
                    maxHeight = Int(cloud.frame.height)
                }
            }
            
            cloud.frame = CGRect(x: xAxis, y: yAxis, width: Int(cloud.frame.size.width), height: Int(cloud.frame.size.height))
            view.addSubview(cloud)
            cloud.layoutIfNeeded()
            xAxis += Int(cloud.frame.width) + padding
        }
    }
    
    func hide() {
        view.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.alpha = 0
        }, completion: { _ in
            if !self.hidden {
                self.removeViewFromWindow()
                self.hidden = true
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
}
