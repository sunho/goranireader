//
//  SentenceUtil.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation

struct SentenceUtill {
    static func removePunctuations(_ word: String) -> String {
        return word.replacingOccurrences(of: "[.!?,]+", with: "", options: .regularExpression)
    }
    
    static func getFrontMiddleEnd(_ sentence: String, _ index: Int, maxChar: Int = 120) -> (String, String, String) {
        let arr = sentence.components(separatedBy: " ")
        
        var front = ""
        var end = ""
        
        if arr.count > index {
            let frontarr = arr[...(index - 1)]
            front = frontarr.joined(separator: " ")
            
            let endarr = arr[(index + 1)...]
            end = endarr.joined(separator: " ")
        }
        
        // trim
        var frontLength = 0
        let candidate1 = min(front.count, maxChar / 2)
        let candidate2 = min(end.count, maxChar / 2)
        if candidate1 < candidate2 {
            frontLength = candidate1
        } else {
            frontLength = maxChar - candidate2
        }
        
        front = String(front.suffix(frontLength))
        end = String(end.prefix(maxChar - frontLength))
        return (front, " \(arr[index]) ", end)
    }
}

