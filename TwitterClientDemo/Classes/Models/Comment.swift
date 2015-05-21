//
//  Comment.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class Comment: NSObject {
    var text: String
    var user: User
    var replyTo: User
    
    init(text: String, user: User, replyTo: User) {
        self.text = text
        self.user = user
        self.replyTo = replyTo
    }
}

extension Comment: Printable {
    override var description: String {
        return "text: \(self.text), user: \(self.user.screenName), replyTo: \(self.replyTo.screenName)"
    }
}