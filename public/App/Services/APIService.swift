import Foundation
import Moya
import ReactiveSwift
import ReactiveMoya
import Result

class APIProvider {
    fileprivate let provider: MoyaProvider<API>
    fileprivate let online: SignalProducer<Bool, NoError>
    var token: String?
    
    init(token: String?) {
        self.token = token
        provider = MoyaProvider(endpointClosure: endpointsClosure,
                                     requestClosure: MoyaProvider<API>.defaultRequestMapping,
                                     stubClosure: MoyaProvider.neverStub,
                                     manager: MoyaProvider<API>.defaultAlamofireManager(),
                                     plugins: APIProvider.plugins,
                                     trackInflights: false)
        online = ReachabilityService.shared.reach.producer
    }
    
    func request(_ target: API) -> SignalProducer<Response, MoyaError> {
        let req = provider.reactive.request(target)
        return online
            .filter({(b: Bool) -> Bool in return b })
            .take(first: 1)
            .promoteError(MoyaError.self)
            .timeout(after: 1.0, raising: MoyaError.underlying("offline", nil), on: QueueScheduler.main)
            .flatMap(.latest) { _ in
                req
            }
    }
    
    func endpointsClosure(_ target: API) -> Endpoint {
        var endpoint: Endpoint = Endpoint(url: URL(target: target).absoluteString, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: nil)
        
        if let tok = self.token {
            endpoint = endpoint.adding(newHTTPHeaderFields: ["Authorization": "Bearer \(tok)"])
        }
        
        return endpoint
    }
    
    static var plugins: [PluginType] {
        return []
    }
}
