//
//  User.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String!
    var name: String!
    var screenName: String!
    var profileImage: String!
    var following: Bool!
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id_str"] as? String
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String
        self.profileImage = dictionary["profile_image_url_https"] as? String
        self.following = dictionary["following"] as? Bool
    }
}

extension User: Printable {
    override var description: String {
        return "id: \(self.id), name: \(self.name), screenName: \(self.screenName), profileImage: \(self.profileImage), following: \(self.following)\n"
    }
}