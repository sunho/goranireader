//
//  FirebaseService.swift
//  app
//
//  Created by Sunho Kim on 10/09/2019.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    static var shared = FirebaseService()
    
    init() {
    }
    
    fileprivate func authorize() -> FirebaseAuth.User {
        return Auth.auth().currentUser!
    }
    
    func login(word: String, word2: String, number: String, completion: @escaping (_ exists: Bool, _ replacing: Bool, _ error: Error?) -> Void) {
        let user = authorize()
        Firestore.firestore().collection("users").whereField("secretCode", isEqualTo: "\(word)-\(word2)-\(number)").getDocuments { docs, error  in
            if error != nil {
                completion(false, false, error)
                return
            }
            if docs?.count ?? 0 == 0 {
                completion(false, false, nil)
                return
            }
            let doc = docs!.documents[0]
            let oldId = doc.data()["fireId"]
            let replacing = oldId as? String != user.uid
            doc.setValue(user.uid, forKey: "fireId")
            Firestore.firestore().collection("fireUsers").document(user.uid).setData([
                "userId": doc.documentID
            ])
            completion(true, replacing, nil)
        }
    }

}
