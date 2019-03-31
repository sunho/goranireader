//
//  SentenceUtil.swift
//  app
//
//  Created by sunho on 2019/03/22.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import UIKit

struct SentenceUtil {
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
    
    // https://stackoverflow.com/questions/32168581/split-paragraphs-into-sentences
    static func splitParagraph(_ paragraph: String) -> [String] {
        var r = [Range<String.Index>]()
        let t = paragraph.linguisticTags(
            in: paragraph.startIndex..<paragraph.endIndex,
            scheme: NSLinguisticTagScheme.lexicalClass.rawValue,
            tokenRanges: &r)
        var result = [String]()
        let ixs = t.enumerated().filter {
            $0.1 == "SentenceTerminator"
            }.map {r[$0.0].lowerBound}
        var prev = paragraph.startIndex
        for ix in ixs {
            let r = prev...ix
            result.append(
                paragraph[r].trimmingCharacters(
                    in: NSCharacterSet.whitespaces))
            prev = paragraph.index(after: ix)
        }
        return result
    }
    
    static func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}

