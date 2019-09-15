//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import FirebaseAuth
import Reachability

class EventLogService {
    static var shared = EventLogService()
    
    init() {
    }

    func send() {
        if RechabilityService.shared.reach {
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    return
                }
                guard let idToken = idToken else {
                    return
                }
                for ev in RealmService.shared.getEventLogs() {
                    let id = ev.id
                    let obj = EventLogMap(type: ev.type, time: ev.time, payload: ev.payload)
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.sendOne(obj, id: id, token: idToken)
                    }
                }
            }
        }
    }
    
    func sendOne(_ ev: EventLogMap, id: String, token: String) {
        let url = URL(string: "https://asia-northeast1-gorani-reader-249509.cloudfunctions.net/addLog")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601withFractionalSeconds
        request.httpBody = try! encoder.encode(ev)
        request.timeoutInterval = 50
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            DispatchQueue.main.async {
                RealmService.shared.deleteEventLog(id)
            }
        }
        task.resume()
    }
}
