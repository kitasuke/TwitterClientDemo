//
//  TwitterStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Accounts

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
}