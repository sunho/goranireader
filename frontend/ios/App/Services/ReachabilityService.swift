//
//  ReachabilityService.swift
//  app
//
//  Created by Sunho Kim on 15/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import Reachability

class RechabilityService {
    static var shared = RechabilityService()
    var reach: Bool = false
    private let _reach = Reachability()!
    init() {
        _reach.whenReachable = { reachability in
            self.reach = true
        }
        _reach.whenUnreachable = { _ in
            self.reach = false
        }
        try! _reach.startNotifier()
    }
}
