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
        
        TwitterStore.sharedStore.login { [unowned self] (result: Result<[ACAccount]>) -> Void in
            let alertController: UIAlertController
            if let error = result.error {
                alertController = LoginAlert.Failure.alertController
                self.presentViewController(alertController, animated: true, completion: nil)
                
                // make it enabled to try again
                self.loginButton?.enabled = true
                return
            }
            
            if let accounts = result.value {
                alertController = LoginAlert.Account(accounts: accounts, completionHandler: { (account) -> Void in
                    self.setupAccount(account)
                }).alertController
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    // MARK: - Account manager
    
    private func setupAccount(account: ACAccount) {
        UserStore.sharedStore.account = account
        
        let alertController = LoginAlert.Success(name: account.username, completionHandler: openHome).alertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Completion handler
    
    private var openHome = { () -> Void in
        let rootViewController = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
}