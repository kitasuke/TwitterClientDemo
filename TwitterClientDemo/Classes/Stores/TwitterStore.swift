//
//  TwitterStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Accounts
import Social

class TwitterStore {
    
    static let sharedStore = TwitterStore()
    
    internal func login(completionHandler: (Result<[ACAccount]>) -> Void) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            if error != nil {
                completionHandler(Result(error))
                return
            }
            
            if !granted {
                completionHandler(Result(NSError()))
                return
            }

            if let accounts = accountStore.accountsWithAccountType(accountType) as? [ACAccount] where accounts.count > 0 {
                completionHandler(Result(accounts))
                return
            }
            completionHandler(Result(NSError()))
        }
    }
    
    internal func fetchFollowers(completionHandler: (Result<[String: AnyObject]>) -> Void, nextCursor: Int?) {
        let cursor = nextCursor ?? -1 // TODO
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: .GET,
            URL: API.Followers.pathURL,
            parameters: ["cursor": String(cursor)]) // convert to String, otherwise it'll ignored
        request.account = UserStore.sharedStore.account
        
        request.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                completionHandler(Result(error))
                return
            }
            
            let result = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil) as! NSDictionary
            if let error = result["errors"] as? NSArray, let info = error.firstObject as? NSDictionary, let code = info["code"] as? Int, let message = info["message"] as? String {
                let errorInfo = NSError(domain: "TwitterClientDemo", code: code, userInfo: [NSLocalizedDescriptionKey: message])
                completionHandler(Result(errorInfo))
                return
            }
            
            let paginator = Paginator(nextCursor: result["next_cursor"] as! Int, previousCursor: result["previous_cursor"] as! Int)
            
            var users = [User]()
            for user in result["users"] as! [NSDictionary] {
                users.append(User(dictionary: user))
            }
            completionHandler(Result(["paginator": paginator, "users": users]))
        }
    }
    
    internal func fetchTimeline(completionHandler: (Result<[Tweet]>) -> Void, sinceID: String?) {
        let tweedID = sinceID ?? ""
        
        let baseParams = ["user_id": UserStore.sharedStore.currentUser!.id, "count": "20"]
        var params = baseParams
        if let tweedID = sinceID {
            params["since_id"] = tweedID
        }
        
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: .GET,
            URL: API.Tileline.pathURL,
            parameters: params)
        request.account = UserStore.sharedStore.account
        
        request.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                completionHandler(Result(error))
                return
            }
            
            let result = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil) as! NSArray
            
            var tweets = [Tweet]()
            for tweet in result as! [NSDictionary] {
                tweets.append(Tweet(dictionary: tweet))
            }
            completionHandler(Result(tweets))
        }
    }
    
    internal func fetchMe(completionHandler: (Result<User>) -> Void) {
        let account = UserStore.sharedStore.account!
        let params = ["screen_name": account.username]
        self.fetchUser(params, completionHandler: completionHandler)
    }
    
    internal func fetchUser(userID: String, userName: String, completionHandler: (Result<User>) -> Void) {
        let params = ["user_id": userID, "screen_name": userName]
        self.fetchUser(params, completionHandler: completionHandler)
    }
    
    private func fetchUser(params: [NSObject: AnyObject], completionHandler: (Result<User>) -> Void) {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: .GET,
            URL: API.User.pathURL,
            parameters: params)
        request.account = UserStore.sharedStore.account
        
        request.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                completionHandler(Result(error))
                return
            }
            
            // parse and object map
            let result = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil) as! NSDictionary
            let user = User(dictionary: result)
            
            // store user data as me or other
            if user.screenName == UserStore.sharedStore.account?.username {
                UserStore.sharedStore.me = user
            } else {
                UserStore.sharedStore.currentUser = user
            }
            
            completionHandler(Result(user))
        }
    }
}