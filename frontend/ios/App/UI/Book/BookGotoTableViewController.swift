//
//  BookGotoTableViewController.swift
//  app
//
//  Created by Sunho Kim on 07/10/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import UIKit

protocol BookGotoDelegate {
    func gotoResolve(_ chapter: Chapter)
}

class BookGotoTableViewController: UITableViewController {
    var delegate: BookGotoDelegate!
    var chapters: [Chapter]!
    var currentChapter: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.gotoResolve(chapters[indexPath.row])
        delegate = nil
        navigationController?.popViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        if chapters[indexPath.row].id == currentChapter {
            cell.contentView.backgroundColor = Color.gray
        } else {
            cell.contentView.backgroundColor = Color.white
        }
        cell.textLabel?.text = chapters[indexPath.row].title
        
        return cell
    }
}
