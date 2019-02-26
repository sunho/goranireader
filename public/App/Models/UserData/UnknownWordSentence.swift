//
//  UnknownWordSentence.swift
//  app
//
//  Created by sunho on 2019/02/23.
//  Copyright © 2019 sunho. All rights reserved.
//

import Foundation
import SQLite

fileprivate let sentenceField = Expression<String>("sentence")
fileprivate let indexField = Expression<Int>("index")
fileprivate let bookField = Expression<String>("book")
