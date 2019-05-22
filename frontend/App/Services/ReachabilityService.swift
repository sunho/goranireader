//
//  Copyright © 2019 Sunho Kim. All rights reserved.
//

import Reachability
import ReactiveSwift

class ReachabilityService {
    static let shared = ReachabilityService()
    
    fileprivate let reachability: Reachability
    let reach: MutableProperty<Bool>
    
    init() {
        reach = MutableProperty(false)
        reachability = Reachability()!
        try! reachability.startNotifier()
        
        reach.value = reachability.connection != .none
        
        self.reachability.whenReachable = { _ in
            DispatchQueue.main.async { self.reach.value = true }
        }
        
        self.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async { self.reach.value = false }
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}
