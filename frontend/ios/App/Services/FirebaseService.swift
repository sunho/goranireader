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
    
    func getBooks() -> Promise<[Book]> {
        return db().collection("books").getDocumentsPromise().then { res -> [Book] in
            return res.documents.flatMap { doc in
                let out = try? FirestoreDecoder().decode(Book.self, from: doc.data())
                return out
            }
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
        return Promise<FirebaseAuth.User> { fulfill, reject in
            guard let user = self.authorize() else {
                reject(GoraniError.internalError)
                return
            }
            fulfill(user)
        }.then{ user in
            return self.db().collection("users")
                .whereField("fireId", isEqualTo: user.uid).getDocumentsPromise().then { res in
                if res.count == 0 {
                    throw GoraniError.nilResult
                }
                return Promise(res.documents[0])
            }
        }
        
    }
    
    func getClass() -> Promise<Class> {
        return getUserDoc().then { udoc -> Promise<DocumentSnapshot> in
            guard let classId = udoc.data()?[safe: "classId"] as? String else {
                throw GoraniError.internalError
            }
            return self.db()
                .collection("classes")
                .document(classId)
                .getDocumentPromise()
        }.then { doc -> Class in
            guard let data = doc.data(),
                  let out = try? FirestoreDecoder()
                    .decode(Class.self, from: data) else {
                throw GoraniError.internalError
            }
            return out
        }
    }
    
    fileprivate func db() -> Firestore {
        return Firestore.firestore()
    }
    
    fileprivate func authorize() -> FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    // TODO convert to promise
    func login(word: String, word2: String, number: String, completion: @escaping (_ exists: Bool, _ replacing: Bool, _ error: Error?) -> Void) {
        Firestore.firestore().collection("users").whereField("secretCode", isEqualTo: "\(word)-\(word2)-\(number)").getDocuments { docs, error  in
            guard let user = self.authorize() else {
                completion(false, false, GoraniError.internalError)
                return
            }
            
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
                    completion(true, replacing, nil)
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
