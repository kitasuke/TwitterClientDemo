//
//  FollowersViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TwitterStore.sharedStore.fetchFollowers { (result: Result<NSDictionary>) -> Void in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

