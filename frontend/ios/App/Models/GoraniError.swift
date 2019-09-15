//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

import Foundation

enum GoraniError: Error {
    case ns(error: NSError)
    case offline
    case system
    case notFound
    case nilResult
    case internalError
    case noauth
}
