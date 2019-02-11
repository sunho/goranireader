//
//  API.swift
//  app
//
//  Created by sunho on 2019/02/11.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import Alamofire

class API {
    let serverURL = "http://localhost:8081"
    
    static let shared = API()
    
    func getBooks(success:@escaping (_ response : [Book])->(), failure : @escaping (_ error : Error)->()) {
        Alamofire.request(URL(string: serverURL + "/books/")!, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    if let books = try? JSONDecoder().decode([Book].self, from: data) {
                        success(books)
                    }
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}


