//
//  ContentService.swift
//  app
//
//  Created by sunho on 2019/03/17.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import FolioReaderKit
import ReactiveSwift
import Result
import Kingfisher
import Moya
import Regex
import UIKit

fileprivate let epubPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\-epub", groupNames: "id", "timestamp")
fileprivate let sensPattern = try! Regex(pattern:"([0-9]+)-([0-9]+)\\.sens", groupNames: "id", "timestamp")

class ContentService {
    static let shared = ContentService()
    
    init() {
    }
    
    func downloadContent(_ content: DownloadableContent) -> SignalProducer<Float, GoraniError> {
        let file: String = {
            if content.type == .epub {
                return "\(content.id)-\(Int(Date().timeIntervalSince1970))-epub.epub"
            } else {
                return "\(content.id)-\(Int(Date().timeIntervalSince1970)).sens"
            }
        }()
        
        let url = FileUtil.downloadDir.appendingPathComponent(file)
        
        return APIService.shared.requestWithProgress(.download(url: content.downloadUrl, file: file))
            .map { (resp: ProgressResponse) -> Float in
                return Float(resp.progress)
            }
            .mapError { (error: MoyaError) -> GoraniError in
                return GoraniError.network(error: error)
            }
            .concat(
                {
                    switch content.type {
                    case .epub:
                        return SignalProducer<Float, GoraniError> { (observer, _) -> Void in
                            do {
                                print(url.absoluteString)
                                let _ = try FREpubParser().readEpub(epubPath: url.path, removeEpub: true, unzipPath: FileUtil.booksDir.path)
                                observer.sendCompleted()
                            } catch let error as FolioReaderError {
                                observer.send(error: GoraniError.folio(error: error))
                            } catch {
                                observer.sendInterrupted()
                            }
                        }
                    case .sens:
                        return SignalProducer<Float, GoraniError> { (observer, _) -> Void in
                            do {
                                try FileManager.default.moveItem(at: url, to: FileUtil.booksDir.appendingPathComponent(file))
                                observer.sendCompleted()
                            } catch let error as NSError {
                                observer.send(error: GoraniError.ns(error: error))
                            } catch {
                                observer.sendInterrupted()
                            }
                        }
                    }
                }()
            )
    }
    
    func getContents() -> SignalProducer<[Content], NoError> {
        return getDownloadedContents()
            .observe(on: QueueScheduler(qos: .utility))
            .flatMap(.latest) { (downloadedContents: [Content]) -> SignalProducer<[Content], NoError> in
                return self.getDownloadableContents()
                    .map { (downloadableContents: [Content]) -> [Content] in
                        return downloadedContents.sorted(by: { $0.updatedAt > $1.updatedAt}) + downloadableContents.sorted(by: { $0.updatedAt > $1.updatedAt})
                    }
                    .flatMapError { _ -> SignalProducer<[Content], NoError> in
                        return SignalProducer<[Content], NoError>(value: downloadedContents.sorted(by: { $0.updatedAt > $1.updatedAt}))
                    }
            }
    }
    
    func getDownloadedContents() -> SignalProducer<[Content], NoError> {
        return SignalProducer { (observer, _) in
            let localContents = self.getLocalContents()
            var out: [Content] = []
            for (key, path) in localContents {
                switch key.type {
                case .epub:
                    guard let epub = try? FREpubParser().readEpub(bookBasePath: path) else {
                        continue
                    }
                    let progress = RealmService.shared.getEpubProgress(key.id)
                    out.append(DownloadedContent(epub: epub, id: key.id, updatedAt: progress.updatedAt, path: path, progress: progress.progress))
                case .sens:
                    guard let sens = try? Sens(path: path) else {
                        continue
                    }
                    out.append(DownloadedContent(sens: sens, updatedAt: Date(), path: path, progress: 0))
                }
            }
            observer.send(value: out)
            observer.sendCompleted()
        }
    }
    
    fileprivate func getLocalContents() -> Dictionary<ContentKey, String> {
        guard let paths = FileUtil.contentsOfDirectory(path: FileUtil.booksDir.path) else {
            assert(true)
            return [:]
        }

        var visit: Dictionary<ContentKey, Int> = [:]
        var out: Dictionary<ContentKey, String> = [:]
        for path in paths {
            let filename = (path as NSString).lastPathComponent
            let epubMatch = epubPattern.findFirst(in: filename)
            let sensMatch = sensPattern.findFirst(in: filename)
            if let match = epubMatch ?? sensMatch {
                guard let id = Int(match.group(named: "id") ?? "die") else {
                    continue
                }
                guard let timestamp = Int(match.group(named: "timestamp") ?? "die") else {
                    continue
                }
                let type: ContentType = epubMatch != nil ? .epub : .sens
                let key = ContentKey(id: id, type: type)
                if let current = visit[key] {
                    if timestamp < current {
                        continue
                    }
                }
                out[key] = path
                visit[key] = timestamp
            }
        }
        return out
    }
    
    func getDownloadableContents() -> SignalProducer<[Content], GoraniError> {
        let localContents = getLocalContents()
        return APIService.shared.request(.listBooks)
            .filterSuccessfulStatusCodes()
            .map([Book].self)
            .mapError { (error: MoyaError) -> GoraniError in
                return .network(error: error)
            }
            .map { (books: [Book]) -> [Content] in
                var out: [Content] = []
                for book in books {
                    if localContents[ContentKey(id: book.id, type: .sens)] == nil && book.sens != nil {
                        out.append(DownloadableContent(book: book, type: .sens, downloadUrl: book.sens!))
                    }
                    if localContents[ContentKey(id: book.id, type: .epub)] == nil && book.epub != nil {
                        out.append(DownloadableContent(book: book, type: .epub, downloadUrl: book.epub!))
                    }
                }
                return out
            }
    }
}
