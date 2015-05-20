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
                alertController = LoginAlert.Failure.alertController
                self.presentViewController(alertController, animated: true, completion: nil)
                
                // make it enabled to try again
                self.loginButton?.enabled = true
                return
            }
            
            if let account = result.value {
                alertController = LoginAlert.Success(name: account.username, completionHandler: self.completionHandler).alertController
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    // MARK: - Completion handler
    
    private var completionHandler = { () -> Void in
        let rootViewController = UIStoryboard(name: StoryboardName.Home.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
        UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
    }
}