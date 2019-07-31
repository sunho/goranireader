//
//  FolioReaderWebView.swift
//  FolioReaderKit
//
//  Created by Hans Seiffert on 21.09.16.
//  Copyright (c) 2016 Folio Reader. All rights reserved.
//

import UIKit

/// The custom WebView used in each page
open class FolioReaderWebView: UIWebView {
    var isOneWord = false

    fileprivate weak var readerContainer: FolioReaderContainer?

    fileprivate var readerConfig: FolioReaderConfig {
        guard let readerContainer = readerContainer else { return FolioReaderConfig() }
        return readerContainer.readerConfig
    }

    fileprivate var book: FRBook {
        guard let readerContainer = readerContainer else { return FRBook() }
        return readerContainer.book
    }

    fileprivate var folioReader: FolioReader {
        guard let readerContainer = readerContainer else { return FolioReader() }
        return readerContainer.folioReader
    }

    override init(frame: CGRect) {
        fatalError("use init(frame:readerConfig:book:) instead.")
    }

    init(frame: CGRect, readerContainer: FolioReaderContainer) {
        self.readerContainer = readerContainer
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIMenuController
//
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ask(_:)) {
            return true
        }
        return false
    }

    open func selectionChanged() {
        let bookName = self.book.name ?? ""
        if let data = js("getSelectedSentence()")?.data(using: .utf8), let sentence = try? JSONDecoder().decode(SelectedSentence.self, from: data) {
                var rect = NSCoder.cgRect(for: js("getRectForSelection()")!)
                rect.origin.y += frame.origin.y
                let point = CGPoint(x: rect.minX, y: rect.minY)
                folioReader.delegate?.selectionChanged(bookName: bookName, point: point, sentence: sentence)
        } else {
            folioReader.delegate?.selectionChanged(bookName: bookName, point: CGPoint(), sentence: nil)
        }
    }

    @objc func ask(_ sender: UIMenuController?) {
        let selected = js("getSelectedText()")

        folioReader.delegate?.ask(selected)
    }

    // MARK: - Create and show menu

    func createMenu() {
        let menuController = UIMenuController.shared

        let askItem = UIMenuItem(title: "질문하기", action: #selector(ask(_:)))
        let menuItems = [askItem]

        menuController.menuItems = menuItems
    }
    
    open func setMenuVisible(_ menuVisible: Bool, animated: Bool = true, andRect rect: CGRect = CGRect.zero) {
        if menuVisible  {
            if !rect.equalTo(CGRect.zero) {
                UIMenuController.shared.setTargetRect(rect, in: self)
            }
        }
        
        UIMenuController.shared.setMenuVisible(menuVisible, animated: animated)
    }
    
    // MARK: - Java Script Bridge
    
    @discardableResult open func js(_ script: String) -> String? {
        let callback = self.stringByEvaluatingJavaScript(from: script)
        if callback!.isEmpty { return nil }
        return callback
    }
    
    // MARK: WebView
    
    func clearTextSelection() {
        // Forces text selection clearing
        // @NOTE: this doesn't seem to always work
        
        self.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
    }
    
    func setupScrollDirection() {
        switch self.readerConfig.scrollDirection {
        case .vertical, .defaultVertical, .horizontalWithVerticalContent:
            scrollView.isPagingEnabled = false
            paginationMode = .unpaginated
            scrollView.bounces = true
            break
        case .horizontal:
            scrollView.isPagingEnabled = true
            paginationMode = .leftToRight
            paginationBreakingMode = .page
            scrollView.bounces = false
            break
        }
    }
}
