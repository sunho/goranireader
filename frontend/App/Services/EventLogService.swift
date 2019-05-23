//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

class EventLogService {
    static var shared = EventLogService()
    
    init() {
    }
    
    func send<T: EventLogPayload>(_ payload: T) {
        RealmService.shared.addEventLog(payload)
        for ev in RealmService.shared.getEventLogs() {
            APIService.shared.request(.createEventLog(evlog: ev))
                .handle(ignoreError: true) { offline, _ in
                    if !offline {
                        RealmService.shared.clearEventLogs()
                    }
                }
        }
    }
}
