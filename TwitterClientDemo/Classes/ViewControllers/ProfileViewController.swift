//
//  ProfileViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var profileDetailView: ProfileDetailView?
    @IBOutlet weak var tableView: UITableView?
    private var tweets = [Tweet]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        profileDetailView?.setup()
        self.setupTableView()
        
        self.fetchTimeline()
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(tweets)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(CellName.Tweet.rawValue, forIndexPath: indexPath) as! TweetCell
        cell.setup(tweet)
        return cell
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = UserStore.sharedStore.currentUser?.name
    }
    
    private func setupTableView() {
        tableView?.registerNib(UINib(nibName: CellName.Tweet.rawValue, bundle: nil), forCellReuseIdentifier: CellName.Tweet.rawValue)
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
