//
//  APIService.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import Moya

enum API {
    case listReviews(bookId: Int, p: Int)
    case createReview(bookId: Int, review: Review)
    case updateReview(bookId: Int, review: Review)
    case deleteReview(bookId: Int)
    case getMyReview(bookId: Int)
    case rateReview(bookId: Int, reviewId: Int, rate: Int)
    
    case listMemories(word: String, p: Int)
    case createMemory(word: String, sentence: String)
    case deleteMemory(word: String)
    case getMyMemory(word: String)
    case rateMemory(word: String, memoryId: Int, rate: Int)
    
    case listBooks
    
    case searchShopBooks(name: String, p: Int, orderBy: String)
    case getShopBook(bookId: Int)
    case buyShopBook(bookId: Int)
    case listCategories
    
    case getRecommendInfo
    case updateRecommendInfo(info: RecommendInfo)
    case listRecommendedBooks
    case rateRecommendedBook(bookId: Int, rate: Int)
    
    case listSensResults
    case updateSensResult(result: SensResult)
    case listQuizResults
    case updateQuizResult(result: QuizResult)
    
    case register(username: String, password: String, email: String)
    case login(username: String, password: String)
    case checkAuth
    
    case createEventLog(evlog: EventLog)
    
    case download(url: String, file: String)
}

extension API: TargetType {
    public var baseURL: URL {
        if case .download(let url, _) = self {
            return URL(string: url.replacingOccurrences(of: "127.0.0.1", with: "172.30.1.20")) ?? URL(string: "http://fnfnffnfnfn.asdf")!
        } else {
            return URL(string: "http://172.30.1.20:8081")!
        }
    }
    
    public var path: String {
        switch self {
        case .download:
            return ""
        case .listReviews(let id, _):
            return "/shop/book/\(id)/review"
        case .createReview(let id, _):
            return "/shop/book/\(id)/review"
        case .updateReview(let id, _):
            return "/shop/book/\(id)/review/my"
        case .deleteReview(let id):
            return "/shop/book/\(id)/review/my"
        case .getMyReview(let id):
            return "/shop/book/\(id)/review/my"
        case .rateReview(let bid, let rid, _):
            return "/shop/book/\(bid)/review/\(rid)/rate"
        case .listMemories(let word, _):
            return "/memory/\(word)"
        case .createMemory(let word, _):
            return "/memroy/\(word)"
        case .deleteMemory(let word):
            return "/memory/\(word)/my"
        case .getMyMemory(let word):
            return "/memory/\(word)/my"
        case .rateMemory(let word, let mid, _):
            return "/memory/\(word)/\(mid)/rate"
        case .listBooks:
            return "/book"
        case .searchShopBooks:
            return "/shop/book"
        case .getShopBook(let id):
            return "/shop/book/\(id)"
        case .buyShopBook(let id):
            return "/shop/book/\(id)/buy"
        case .listCategories:
            return "/shop/category"
        case .getRecommendInfo:
            return "/recommend/info"
        case .updateRecommendInfo:
            return "/recommend/info"
        case .listRecommendedBooks:
            return "/recommend/book"
        case .rateRecommendedBook(let id):
            return "/recommend/book/\(id)/rate"
        case .listSensResults:
            return "/result/sens"
        case .updateSensResult(let result):
            return "/result/sens/\(result.bookId)/\(result.sensId)"
        case .listQuizResults:
            return "/result/quiz"
        case .updateQuizResult(let result):
            return "/result/quiz/\(result.bookId)/\(result.quizId)"
        case .register:
            return "/user"
        case .login:
            return "/user/login"
        case .checkAuth:
            return "/user/me"
        case .createEventLog:
            return "/evlog"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .download:
            return .get
        case .listReviews, .listMemories, .getMyReview, .listBooks, .getMyMemory, .listCategories,
             .getShopBook, .searchShopBooks, .listRecommendedBooks, .getRecommendInfo,
             .listQuizResults, .listSensResults, .checkAuth:
            return .get
        case .createReview, .createMemory, .buyShopBook, .register, .login, .createEventLog:
            return .post
        case .updateReview, .rateReview, .rateMemory, .updateRecommendInfo,
             .rateRecommendedBook,
             .updateQuizResult, .updateSensResult:
            return .put
        case .deleteReview, .deleteMemory:
            return .delete
        }
    }
    
    //TODO
    var downloadDestination: DownloadDestination {
        return { [self] (url, resp) in
            if case .download(_, let file) = self {
                return (FileUtil.downloadDir.appendingPathComponent(file), .removePreviousFile)
            }
            return (FileUtil.downloadDir.appendingPathComponent(url.lastPathComponent), .removePreviousFile)
        }
    }
    
    public var task: Task {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        switch self {
        case .download:
            return .downloadDestination(downloadDestination)
        case .listReviews(_, let p), .listMemories(_, let p):
            return .requestParameters(parameters: ["p": p], encoding: URLEncoding.default)
        case .createMemory(_, let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createReview(_, let body), .updateReview(_, let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createEventLog(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .updateRecommendInfo(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .rateReview(_, _, let rate), .rateMemory(_, _, let rate), .rateRecommendedBook(_, let rate):
            return .requestCustomJSONEncodable(["rate": rate], encoder: encoder)
        case .searchShopBooks(let name, let p, let orderBy):
            return .requestParameters(parameters: ["name": name, "p": p, "by": orderBy], encoding: URLEncoding.default)
        case .updateSensResult(let result):
            return .requestCustomJSONEncodable(result, encoder: encoder)
        case .updateQuizResult(let result):
            return .requestCustomJSONEncodable(result, encoder: encoder)
        case .register(let username, let password, let email):
            return .requestCustomJSONEncodable(["username": username, "password": password, "email": email], encoder: encoder)
        case .login(let username, let password):
            return .requestCustomJSONEncodable(["username": username, "password": password], encoder: encoder)
        case .getMyReview, .listBooks, .getMyMemory, .listCategories, .getShopBook,
             .listRecommendedBooks, .getRecommendInfo,
             .listQuizResults, .listSensResults, .buyShopBook,
             .deleteReview, .deleteMemory, .checkAuth:
            return .requestPlain
        }
    }
    
    // ha ha ha
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
