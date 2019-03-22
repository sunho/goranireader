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
    case createMemory(word: String, memory: Memory)
    case updateMemory(word: String, memory: Memory)
    case deleteMemory(word: String)
    case getMyMemory(word: String)
    case rateMemory(word: String, memoryId: Int, rate: Int)
    
    case listBooks
    
    case searchShopBooks(name: String, p: Int)
    case getShopBook(bookId: Int)
    case buyShopBook(bookId: Int)
    case listCategories
    
    case getRecommendInfo
    case updateRecommendInfo(info: RecommendInfo)
    case listRecommendedBooks
    case rateRecommendedBook(bookId: Int, rate: Int)
    
    case addKnownWord(word: String)
    case subtractKnownWord(word: String)
    
    case listSensProgresses
    case updateSensProgress(progress: SensProgress)
    
    case listSensResults
    case updateSensResult(result: SensResult)
    case listQuizResults
    case updateQuizResult(result: QuizResult)
    
    case register(username: String, password: String, email: String)
    case login(username: String, password: String)
    case checkAuth
    
    case download(url: String, file: String)
}

extension API: TargetType {
    public var baseURL: URL {
        if case .download(let url, _) = self {
            return URL(string: url) ?? URL(string: "http://fnfnffnfnfn.asdf")!
        } else {
            return URL(string: "http://127.0.0.1:8081")!
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
        case .updateMemory(let word, _):
            return "/memory/\(word)/my"
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
        case .addKnownWord(let word):
            return "/word/nword/\(word)"
        case .subtractKnownWord(let word):
            return "/word/nword/\(word)"
        case .listSensProgresses:
            return "/progress/sens"
        case .updateSensProgress(let progress):
            return "/progress/sens/\(progress.bookId)"
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
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .download:
            return .get
        case .listReviews, .listMemories, .getMyReview, .listBooks, .getMyMemory, .listCategories,
             .getShopBook, .searchShopBooks, .listRecommendedBooks, .getRecommendInfo,
             .listSensProgresses, .listQuizResults, .listSensResults, .checkAuth:
            return .get
        case .createReview, .createMemory, .buyShopBook, .register, .login:
            return .post
        case .updateReview, .rateReview, .updateMemory, .rateMemory, .updateRecommendInfo,
             .rateRecommendedBook, .addKnownWord, .updateSensProgress,
             .updateQuizResult, .updateSensResult:
            return .put
        case .deleteReview, .deleteMemory, .subtractKnownWord:
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
        switch self {
        case .download:
            return .downloadDestination(downloadDestination)
        case .listReviews(_, let p), .listMemories(_, let p):
            return .requestParameters(parameters: ["p": p], encoding: URLEncoding.default)
        case .createMemory(_, let body), .updateMemory(_, let body):
            return .requestJSONEncodable(body)
        case .createReview(_, let body), .updateReview(_, let body):
            return .requestJSONEncodable(body)
        case .updateRecommendInfo(let body):
            return .requestJSONEncodable(body)
        case .rateReview(_, _, let rate), .rateMemory(_, _, let rate), .rateRecommendedBook(_, let rate):
            return .requestJSONEncodable(["rate": rate])
        case .searchShopBooks(let name, let p):
            return .requestParameters(parameters: ["name": name, "p": p], encoding: URLEncoding.default)
        case .updateSensProgress(let progress):
            return .requestJSONEncodable(progress)
        case .updateSensResult(let result):
            return .requestJSONEncodable(result)
        case .updateQuizResult(let result):
            return .requestJSONEncodable(result)
        case .register(let username, let password, let email):
            return .requestJSONEncodable(["username": username, "password": password, "email": email])
        case .login(let username, let password):
            return .requestJSONEncodable(["username": username, "password": password])
        case .getMyReview, .listBooks, .getMyMemory, .listCategories, .getShopBook,
             .listRecommendedBooks, .getRecommendInfo,
             .listSensProgresses, .listQuizResults, .listSensResults, .buyShopBook,
             .addKnownWord, .deleteReview, .deleteMemory, .subtractKnownWord, .checkAuth:
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
