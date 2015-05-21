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
    
    internal func fetchFollowers(completionHandler: (Result<[String: AnyObject]>) -> Void) {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: .GET,
            URL: API.Followers.pathURL,
            parameters: nil)
        request.account = UserStore.sharedStore.account
        
        request.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                completionHandler(Result(error))
                return
            }
            
            let result = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil) as! NSDictionary
            
            let paginator = Paginator(nextCursor: result["next_cursor"] as! Int, previousCursor: result["previous_cursor"] as! Int)
            
            var users = [User]()
            for user in result["users"] as! [NSDictionary] {
                users.append(User(dictionary: user))
            }
            completionHandler(Result(["paginator": paginator, "users": users]))
        }
    }
    
    internal func fetchMe(completionHandler: (Result<NSDictionary>) -> Void) {
        let account = UserStore.sharedStore.account!
        let params = ["screen_name": account.username]
        self.fetchUser(params, completionHandler: completionHandler)
    }
    
    internal func fetchUser(userID: String, userName: String, completionHandler: (Result<NSDictionary>) -> Void) {
        let params = ["user_id": userID, "screen_name": userName]
        self.fetchUser(params, completionHandler: completionHandler)
    }
    
    private func fetchUser(params: [NSObject: AnyObject], completionHandler: (Result<NSDictionary>) -> Void) {
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
            
            let result = NSJSONSerialization.JSONObjectWithData(data,
                options: .AllowFragments,
                error: nil) as! NSDictionary
            completionHandler(Result(result))
        }
    }
}