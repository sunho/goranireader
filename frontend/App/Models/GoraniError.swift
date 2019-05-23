//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation
import Moya
import FolioReaderKit

enum GoraniError: Error {
    case network(error: MoyaError)
    case folio(error: FolioReaderError)
    case ns(error: NSError)
    case offline
    case system
}

extension MoyaError {
    var isOffline: Bool {
        if case MoyaError.underlying(GoraniError.offline, _) = self {
            return true
        }
        return false
    }
}
