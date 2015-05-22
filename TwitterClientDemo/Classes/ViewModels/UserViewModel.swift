//
//  UserViewModel.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class UserViewModel: NSObject {
    var screenName: String?
    var followersCountString: String?
    var friendsCountString: String?
    
    init(user: User) {
        self.screenName = "@" + user.screenName
        self.followersCountString = "\(user.followersCount)"
        self.friendsCountString = "\(user.friendsCount)"
    }
}