//
//  GoraniError.swift
//  app
//
//  Created by sunho on 2019/03/14.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import Moya
import FolioReaderKit

enum GoraniError: Error {
    case network(error: MoyaError)
    case folio(error: FolioReaderError)
    case ns(error: NSError)
    case offline
}

extension MoyaError {
    var isOffline: Bool {
        if case MoyaError.underlying(GoraniError.offline, _) = self {
            return true
        }
        return false
    }
}
