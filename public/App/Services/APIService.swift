import Foundation
import Moya
import ReactiveSwift
import ReactiveMoya
import Result

class APIService {
    static let shared: APIService = {
        let config = RealmService.shared.getConfig()
        if !config.authorized {
            return APIService(token: nil)
        }
        return APIService(token: config.token)
    }()
    
    fileprivate lazy var provider: MoyaProvider<API> = { [unowned self] in
       return MoyaProvider(endpointClosure: self.endpointsClosure,
                     requestClosure: MoyaProvider<API>.defaultRequestMapping,
                     stubClosure: MoyaProvider.neverStub,
                     manager: MoyaProvider<API>.defaultAlamofireManager(),
                     plugins: self.plugins,
                     trackInflights: false)
    }()
    
    fileprivate let online: SignalProducer<Bool, NoError>
    var token: String? {
        didSet {
            if let token = token {
                let conf = RealmService.shared.getConfig()
                RealmService.shared.write {
                    conf.authorized = true
                    conf.token = token
                }
            }
        }
    }
    
    init(token: String?) {
        self.token = token
        online = ReachabilityService.shared.reach.producer
    }
    
    func request(_ target: API) -> SignalProducer<Response, MoyaError> {
        let req = provider.reactive.request(target)
        return requestInternal(req)
        
    }
    
    func requestWithProgress(_ target: API) -> SignalProducer<ProgressResponse, MoyaError> {
        let req = provider.reactive.requestWithProgress(target)
        return requestInternal(req)
    }
    
    fileprivate func requestInternal<T>(_ req: SignalProducer<T, MoyaError>) -> SignalProducer<T, MoyaError> {
        return online
            .filter({(b: Bool) -> Bool in return b })
            .take(first: 1)
            .promoteError(MoyaError.self)
            .timeout(after: 1.0, raising: MoyaError.underlying("offline", nil), on: QueueScheduler.main)
            .flatMap(.latest) { _ in
                req.observe(on: QueueScheduler(qos: .utility))
            }
    }
    
    func endpointsClosure(_ target: API) -> Endpoint {
        var endpoint: Endpoint = Endpoint(url: URL(target: target).absoluteString, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: nil)
        
        if let tok = self.token  {
            if case .download(_,_) = target {} else {
                endpoint = endpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(tok)"])
            }
        }
        
        return endpoint
    }
    
    fileprivate var plugins: [PluginType] {
        return []
    }
}
