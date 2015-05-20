//
//  AlertStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import UIKit
import Accounts

enum LoginAlert {
    case Success(name: String, completionHandler: () -> Void)
    case Failure
    case Account(accounts: [ACAccount], completionHandler: (account: ACAccount) -> Void)
    
    var alertController: UIAlertController {
        let alertController: UIAlertController
        let alertAction: UIAlertAction
        switch self {
        case .Success(let name, let completionHandler):
            alertController = UIAlertController(title: "Success", message: "Welcome \(name)!", preferredStyle: .Alert)
            alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                completionHandler()
            })
        case .Failure:
            alertController = UIAlertController(title: "Error", message: "Please configure your twitter account in Setting", preferredStyle: .Alert)
            alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            })
        case .Account(let accounts, let completionHandler):
            alertController = UIAlertController(title: "Twitter accounts", message: "Please choose your account", preferredStyle: .ActionSheet)
            for account in accounts {
                alertController.addAction(UIAlertAction(title: account.username, style: .Default, handler: { (action: UIAlertAction!) -> Void in
                    completionHandler(account: account)
                }))
            }
            alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        }
        alertController.addAction(alertAction)
        return alertController
    }
}