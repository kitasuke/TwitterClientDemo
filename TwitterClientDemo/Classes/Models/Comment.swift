//
//  Comment.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import CoreData

class Comment: NSManagedObject {
    @NSManaged var text: String
    @NSManaged var username: String
    @NSManaged var replyTo: String
    @NSManaged var createdAt: NSDate
}

extension Comment: Printable {
    override var description: String {
        return "text: \(self.text), username: \(self.username), replyTo: \(self.replyTo)"
    }
}