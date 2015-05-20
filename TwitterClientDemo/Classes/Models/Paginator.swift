//
//  Paginator.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class Paginator: NSObject {
    var nextCursor: Int!
    var previousCursor: Int!
    var hasNext: Bool!
    var hasPrevious: Bool!
    
    init(nextCursor: Int!, previousCursor: Int!) {
        self.nextCursor = nextCursor
        self.previousCursor = previousCursor
        self.hasNext = nextCursor > 0
        self.hasPrevious = previousCursor > 0
    }
}

extension Paginator: Printable {
    override var description: String {
        return "nextCursor: \(self.nextCursor), previousCursor: \(self.previousCursor), hasNext: \(self.hasNext), hasPrevious: \(self.hasPrevious)"
    }
}