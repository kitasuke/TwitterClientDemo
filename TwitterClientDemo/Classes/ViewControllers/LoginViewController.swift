//
//  LoginViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton?
    
    // MARK: - IBActions
    
    @IBAction func loginWithTwitter(sender: AnyObject) {
        TwitterStore.sharedStore.login()
    }
}