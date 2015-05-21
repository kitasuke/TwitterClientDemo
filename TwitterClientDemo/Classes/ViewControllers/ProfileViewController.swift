//
//  ProfileViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileDetailView: ProfileDetailView?
    @IBOutlet weak var tableView: UITableView?
    private var tweets = [Tweet]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        profileDetailView?.setup()
        self.fetchTimeline()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = UserStore.sharedStore.currentUser?.name
    }
    
    // MARK: - Fetcher
    
    private func fetchTimeline() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            TwitterStore.sharedStore.fetchTimeline { [unowned self] (result: Result<[Tweet]>) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let error = result.error {
                    return
                }
                
                if let tweets = result.value {
                    self.tweets = tweets
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView?.reloadData()
                    })
                }
            }
        })
    }
}
