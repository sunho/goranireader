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
    let serverURL = "https://s3.minda.games"
    
    static let shared = API()
    
    func getBooks(name: String, success:@escaping (_ response : [Book])->(), failure : @escaping (_ error : Error)->()) {
        Alamofire.request(URL(string: serverURL + "/books/")!, method: .get, parameters: ["name": name], encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
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


