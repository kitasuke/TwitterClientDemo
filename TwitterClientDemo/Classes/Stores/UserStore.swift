//
//  UserStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import Accounts

class UserStore {
    static let sharedStore = UserStore()
    
    internal var account: ACAccount? {
        get {
            if let data = NSUserDefaults.standardUserDefaults().dataForKey(UserDefaultsKeyAccount) {
                return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ACAccount
            }
            return nil
        }
        set {
            let data = NSKeyedArchiver.archivedDataWithRootObject(newValue!)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(data, forKey: UserDefaultsKeyAccount)
            userDefaults.synchronize()
        }
    }
}
