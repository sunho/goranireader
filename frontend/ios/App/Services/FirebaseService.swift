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
import CodableFirebase
import Promises

class FirebaseService {
    static var shared = FirebaseService()
    
    init() {
    }
    
    func getOwnedBooks() -> Promise<[Book]> {
        return getUserdata().then { udata in
            print(udata)
            return all(udata.ownedBooks.map { id in
                print(id)
                return self.getBook(id).then { book in
                    return Promise<Book?>(book)
                }.recover { error -> Book? in
                    print("Error while fetching owned book: \(error)")
                    return nil
                }
            })
        }.then { (books: [Book?]) -> [Book] in
            return books.flatMap { $0 }
        }
    }
    
    func getBook(_ id: String) -> Promise<Book> {
        return db().collection("books").document(id).getDocumentPromise().then { doc in
            if !doc.exists {
                throw GoraniError.notFound
            }
            let out = try FirestoreDecoder().decode(Book.self, from: doc.data()!)
            return Promise(out)
        }
    }
    
    func getUserdata() -> Promise<Userdata> {
        return userdataDoc().then { userDoc in
            return userDoc.getDocumentPromise().then { doc in
                return Promise((userDoc, doc))
            }
        }.then { (userDoc, doc) in
            print(userDoc.documentID)
            if !doc.exists {
                print("not sexists")
                let data = try FirestoreEncoder().encode(Userdata())
                return userDoc.setDataPromise(data).then { _ in
                    return Promise(Userdata())
                }
            }
            print(doc.data()!)
            let out = try FirestoreDecoder().decode(Userdata.self, from: doc.data()!)
            print(out)
            return Promise(out)
        }
    }
    
    func userdataDoc() -> Promise<DocumentReference> {
        return getUserDoc().then { doc in
            return Promise(self.db().collection("userdata")
                .document(doc.documentID))
        }
    }
    
    func getUserDoc() -> Promise<DocumentSnapshot> {
        let user = authorize()
        return db().collection("users")
            .whereField("fireId", isEqualTo: user.uid).getDocumentsPromise().then { res in
                if res.count == 0 {
                    throw GoraniError.nilResult
                }
                return Promise(res.documents[0])
            }
    }
    
    fileprivate func db() -> Firestore {
        return Firestore.firestore()
    }
    
    fileprivate func authorize() -> FirebaseAuth.User {
        return Auth.auth().currentUser!
    }
    
    // TODO convert to promise
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
            guard let data = doc.data() as? Dictionary<String, Any> else {
                completion(false, false, error)
                return
            }
            let replacing = data["fireId"] as? String != user.uid
            doc.reference.updateData([
                "fireId": user.uid
            ]) { err in
                if err == nil {
                    return
                }
                fatalError(err!.localizedDescription)
            }
            Firestore.firestore()
                .collection("fireUsers")
                .document(user.uid)
                .setData([
                "userId": doc.documentID
                ]) { err in
                if err == nil {
                    return
                }
                fatalError(err!.localizedDescription)
            }
            completion(true, replacing, nil)
        }
    }
    
    func checkAuth() -> Promise<Bool> {
        return Promise { fulfill, reject in
            self.getUserdata().then { _ in
                RealmService.shared.write {
                    let config = RealmService.shared.getConfig()
                    config.authorized = true
                }
                fulfill(true)
            }.catch { _ in
                RealmService.shared.write {
                    let config = RealmService.shared.getConfig()
                    config.authorized = false
                }
                fulfill(false)
            }
        }
    }
}
