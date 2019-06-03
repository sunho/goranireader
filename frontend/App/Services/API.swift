//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import Moya

enum API {
    case listSimilarWords(word: String)
    
    case listMemories(word: String, p: Int)
    case updateMemory(word: String, sentence: String)
    case getMyMemory(word: String)
    case rateMemory(word: String, memoryId: Int, rate: Int)
    
    case listBooks
    
    case getRecommendInfo
    case updateRecommendInfo(info: RecommendInfo)
    
    case getTargetBookProgress
    
    case searchShopBooks(name: String, p: Int, orderBy: String)
    case getShopBook(bookId: Int)
    case buyShopBook(bookId: Int)
    case getMyBookRate(bookId: Int)
    case rateBook(bookId: Int, rate: Int)
    
    case listCategories
    
    case listRecommendedBooks
    case rateRecommendedBook(bookId: Int, rate: Int)
    case deleteRecommendedBook(bookId: Int)
    
    case listSensResults
    case updateSensResult(result: SensResult)
    case listQuizResults
    case updateQuizResult(result: QuizResult)
    
    case listPosts
    case createPost(post: Post)
    case ratePost(postId: Int, rate: Int)
    
    case listComment(postId: Int)
    case createComment(postId: Int, comment: Comment)
    case markPostSolved(postId: Int, commentId: Int)
    case rateComment(postId: Int, commentId: Int, rate: Int)
    
    case getRateComment(postId: Int, commentId: Int)
    case getRatePost(postId: Int)
    
    case getMissions
    case putMissionProgress(missionId: Int, progress: MissionProgress)
    case getMissionProgress(missionId: Int)
    
    case getUser(userId: Int)
    
    case login(username: String, idToken: String)
    case checkAuth
    
    case createEventLog(evlog: EventLog)
    
    case download(url: String, file: String)
}

extension API: TargetType {
    public var baseURL: URL {
        if case .download(let url, _) = self {
            return URL(string: url.replacingOccurrences(of: "127.0.0.1", with: "172.30.1.47")) ?? URL(string: "http://fnfnffnfnfn.asdf")!
        } else {
            return URL(string: "https://gorani.sunho.kim")!
        }
    }
    
    public var path: String {
        switch self {
        case .download:
            return ""
        case .listSimilarWords(let word):
            return "/memory/\(word)/similar"
        case .listMemories(let word, _):
            return "/memory/\(word)"
        case .updateMemory(let word, _):
            return "/memory/\(word)"
        case .getMyMemory(let word):
            return "/memory/\(word)/my"
        case .rateMemory(let word, let mid, _):
            return "/memory/\(word)/\(mid)/rate"
        case .listBooks:
            return "/book"
        case .getTargetBookProgress:
            return "/recommend/progress"
        case .getRecommendInfo:
            return "/recommend/info"
        case .updateRecommendInfo:
            return "/recommend/info"
        case .searchShopBooks:
            return "/shop/book"
        case .getMyBookRate(let bookId):
            return "/shop/book/\(bookId)/rate"
        case .rateBook(let bookId, _):
            return "/shop/book/\(bookId)/rate"
        case .getShopBook(let id):
            return "/shop/book/\(id)"
        case .buyShopBook(let id):
            return "/shop/book/\(id)/buy"
        case .listCategories:
            return "/shop/category"
        case .listRecommendedBooks:
            return "/recommend/book"
        case .rateRecommendedBook(let id, _):
            return "/recommend/book/\(id)/rate"
        case .deleteRecommendedBook(let bookId):
            return "/recommend/book/\(bookId)"
        case .listSensResults:
            return "/result/sens"
        case .updateSensResult(let result):
            return "/result/sens/\(result.bookId)/\(result.sensId)"
        case .listQuizResults:
            return "/result/quiz"
        case .updateQuizResult(let result):
            return "/result/quiz/\(result.bookId)/\(result.quizId)"
        case .login:
            return "/user/login"
        case .checkAuth:
            return "/user/me"
        case .createEventLog:
            return "/evlog"
        case .listPosts:
            return "/post"
        case .createPost:
            return "/post"
        case .ratePost(let postId, _):
            return "/post/\(postId)/rate"
        case .listComment(let postId):
            return "/post/\(postId)/comment"
        case .markPostSolved(let postId, _):
            return "/post/\(postId)/sentence/solve"
        case .rateComment(let postId, let commentId, _):
            return "/post/\(postId)/comment/\(commentId)/rate"
        case .getUser(let userId):
            return "/user/\(userId)"
        case .createComment(let postId, _):
            return "/post/\(postId)/comment"
        case .getRateComment(let postId, let commentId):
            return "/post/\(postId)/comment/\(commentId)/rate"
        case .getRatePost(let postId):
            return "/post/\(postId)/rate"
        case .getMissions:
            return "/mission"
        case .putMissionProgress(let missionId, _):
            return "/mission/\(missionId)/progress"
        case .getMissionProgress(let missionId):
            return "/mission/\(missionId)/progress"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .download:
            return .get
        case .listMemories, .listBooks, .getMyMemory, .listCategories, .getMissions, .getMissionProgress,
             .getShopBook, .searchShopBooks, .listRecommendedBooks, .getRecommendInfo,
             .listSimilarWords, .getMyBookRate, .listPosts, .listComment, .getUser,
             .listQuizResults, .listSensResults, .checkAuth, .getTargetBookProgress, .getRatePost, .getRateComment:
            return .get
        case .buyShopBook, .login, .createEventLog, .markPostSolved, .createPost, .createComment:
            return .post
        case .rateBook, .rateMemory, .ratePost, .rateComment,
             .rateRecommendedBook, .updateMemory,
             .updateQuizResult, .updateSensResult, .updateRecommendInfo, .putMissionProgress:
            return .put
        case .deleteRecommendedBook:
            return .delete
        }
    }
    
    //TODO what???
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
        case .updateMemory(_, let sentence):
            var memory = Memory()
            memory.sentence = sentence
            return .requestCustomJSONEncodable(memory, encoder: encoder)
        case .putMissionProgress(_, let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createPost(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createComment(_, let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .updateRecommendInfo(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createEventLog(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .rateBook(_, let rate), .rateMemory(_, _, let rate), .rateRecommendedBook(_, let rate), .ratePost(_, let rate), .rateComment(_, _, let rate):
            return .requestCustomJSONEncodable(["rate": rate], encoder: encoder)
        case .markPostSolved(_, let commentId):
            return .requestCustomJSONEncodable(["comment_id": commentId], encoder: encoder)
        case .searchShopBooks(let name, let p, let orderBy):
            return .requestParameters(parameters: ["name": name, "p": p, "by": orderBy], encoding: URLEncoding.default)
        case .listMemories(_, let p):
            return .requestParameters(parameters: ["p": p], encoding: URLEncoding.default)
        case .updateSensResult(let result):
            return .requestCustomJSONEncodable(result, encoder: encoder)
        case .updateQuizResult(let result):
            return .requestCustomJSONEncodable(result, encoder: encoder)
        case .login(let username, let idToken):
            return .requestCustomJSONEncodable(["username": username, "id_token": idToken], encoder: encoder)
    case .getMyBookRate, .listBooks, .getMyMemory, .listCategories, .getShopBook, .listPosts, .listComment, 
             .listRecommendedBooks, .deleteRecommendedBook, .listSimilarWords, .getUser,
             .getMissionProgress, .getMissions,
             .listQuizResults, .listSensResults, .buyShopBook, .getRecommendInfo,
             .checkAuth, .getTargetBookProgress, .getRateComment, .getRatePost:
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
