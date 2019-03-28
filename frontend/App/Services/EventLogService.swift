//
//  EventLogService.swift
//  app
//
//  Created by sunho on 2019/03/29.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

class EventLogService {
    static var shared = EventLogService()
    
    init() {
    }
    
    func send(_ payload: EventLogPayload) {
        RealmService.shared.addEventLog(payload)
        if ReachabilityService.shared.reach.value {
            for ev in RealmService.shared.getEventLogs() {
                APIService.shared.request(.createEventLog(evlog: ev)).start { event in
                    if case .failed(let error) = event {
                        print(error)
                    }
                }
            }
            RealmService.shared.clearEventLogs()
        }
    }
}
