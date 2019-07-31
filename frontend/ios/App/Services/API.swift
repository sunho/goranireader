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
    
    case getMissions
    case putProgress(bookId: Int, progress: Progress)
    case getProgress(bookId: Int)
    
    case getUser(userId: Int)
    
    case login(username: String, idToken: String, code: String)
    case checkAuth
    
    case createEventLog(evlog: EventLog)
    
    case download(url: String, file: String)
}

extension API: TargetType {
    public var baseURL: URL {
        if case .download(let url, _) = self {
            return URL(string: url.replacingOccurrences(of: "127.0.0.1", with: "172.30.1.47")) ?? URL(string: "http://fnfnffnfnfn.asdf")!
        } else {
            return URL(string: "http://localhost:8080")!
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
        case .login:
            return "/user/login"
        case .checkAuth:
            return "/user/me"
        case .createEventLog:
            return "/evlog"
        case .getUser(let userId):
            return "/user/\(userId)"
        case .getMissions:
            return "/mission"
        case .putProgress(let bookId, _):
            return "/progress/\(bookId)"
        case .getProgress(let bookId):
            return "/progress/\(bookId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .download:
            return .get
        case .listMemories, .listBooks, .getMyMemory, .getMissions,
             .getProgress, .listSimilarWords, .getUser,
             .checkAuth:
            return .get
        case .login, .createEventLog:
            return .post
        case .rateMemory,
             .updateMemory,
             .putProgress:
            return .put
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
        case .rateMemory(_, _, let rate):
            return .requestCustomJSONEncodable(["rate": rate], encoder: encoder)
        case .putProgress(_, let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .createEventLog(let body):
            return .requestCustomJSONEncodable(body, encoder: encoder)
        case .listMemories(_, let p):
            return .requestParameters(parameters: ["p": p], encoding: URLEncoding.default)
        case .login(let username, let idToken, let code):
            return .requestCustomJSONEncodable(["username": username, "id_token": idToken, "code": code], encoder: encoder)
        case .listBooks, .getMyMemory,
              .listSimilarWords, .getUser,
             .getProgress, .getMissions,
             .checkAuth:
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
