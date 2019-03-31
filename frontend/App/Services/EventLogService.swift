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
    
    func send<T: EventLogPayload>(_ payload: T) {
        RealmService.shared.addEventLog(payload)
        if ReachabilityService.shared.reach.value {
            for ev in RealmService.shared.getEventLogs() {
                APIService.shared.request(.createEventLog(evlog: ev)).start { event in
                    switch event {
                    case .value:
                        DispatchQueue.main.async {
                            RealmService.shared.clearEventLogs()
                        }
                    default:
//print(event)
                        ()
                    }
                }
            }
            
        }
    }
}
