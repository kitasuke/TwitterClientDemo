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
    var descriptionString: String!
    var followersCount: Int!
    var friendsCount: Int!
    var timeZone: String!
    var URL: String!
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id_str"] as? String
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String
        self.profileImage = dictionary["profile_image_url_https"] as? String
        self.following = dictionary["following"] as? Bool
        self.descriptionString = dictionary["description"] as? String
        self.followersCount = dictionary["followers_count"] as? Int
        self.friendsCount = dictionary["friends_count"] as? Int
        self.timeZone = dictionary["time_zone"] as? String
        self.URL = dictionary["url"] as? String
    }
}

extension User: Printable {
    override var description: String {
        return "id: \(self.id), name: \(self.name), screenName: \(self.screenName), profileImage: \(self.profileImage), following: \(self.following), description: \(self.descriptionString), followersCount: \(self.followersCount), friendsCount: \(self.friendsCount), timeZone: \(self.timeZone), url: \(self.URL)\n"
    }
}