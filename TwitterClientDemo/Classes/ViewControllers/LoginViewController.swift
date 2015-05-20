//
//  LoginViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit
import Accounts

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton?
    
    // MARK: - IBActions
    
    @IBAction func loginWithTwitter(sender: AnyObject) {
        // prevent from double tap
        loginButton?.enabled = false
        
        TwitterStore.sharedStore.login { [unowned self] (result: Result<ACAccount>) -> Void in
            let alertController: UIAlertController
            if let error = result.error {
                alertController = UIAlertController(title: "Error", message: "Please configure your twitter account in Setting", preferredStyle: .Alert)
                let openSetting = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                })
                alertController.addAction(openSetting)
                self.presentViewController(alertController, animated: true, completion: nil)
                self.loginButton?.enabled = true
                return
            }
            
            if let account = result.value {
                alertController = UIAlertController(title: "Success", message: "Welcome \(account.username)!", preferredStyle: .Alert)
                let openFollowerList = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                    let rootViewController = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                    UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
                })
                alertController.addAction(openFollowerList)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
    }
}