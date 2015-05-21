//
//  Tweet.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var id: String!
    var text: String!
    var user: User!
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.text = dictionary["text"] as? String
        self.user = User(dictionary: dictionary["user"] as! NSDictionary)
    }
}

extension Tweet: Printable {
    override var description: String {
        return "id: \(self.id), text: \(self.text), user: \(self.user)"
    }
}