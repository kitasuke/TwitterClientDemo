//
//  URLConstants.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

enum API {
    case Tileline
    case Followers
    case User
    
    var pathURL: NSURL {
        let baseURL = NSURL(string: "https://api.twitter.com/1.1/")
        switch self {
        case .Tileline:
            return NSURL(string: "statuses/user_timeline.json", relativeToURL: baseURL)!
        case .Followers:
            return NSURL(string: "followers/list.json", relativeToURL: baseURL)!
        case .User:
            return NSURL(string: "users/show.json", relativeToURL: baseURL)!
        }
    }
}