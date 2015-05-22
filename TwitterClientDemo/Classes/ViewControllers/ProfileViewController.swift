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
    private var loading = false

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        profileDetailView?.setup()
        self.setupTableView()
        
        self.fetchTimeline(readMore: false)
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // read more if needed
        if !loading && count(tweets) - 10 < indexPath.row { // TODO
//            self.fetchTimeline(readMore: true) // TODO
        }
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = UserStore.sharedStore.currentUser?.name
    }
    
    private func setupTableView() {
        tableView?.registerNib(UINib(nibName: CellName.Tweet.rawValue, bundle: nil), forCellReuseIdentifier: CellName.Tweet.rawValue)
    }
    
    // MARK: - Fetcher
    
    private func fetchTimeline(#readMore: Bool) {
        loading = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { [unowned self] () -> Void in
            let sinceID: String?
            if readMore && count(self.tweets) > 0 {
                sinceID = self.tweets.last?.id
            } else {
                sinceID = nil
            }
            TwitterStore.sharedStore.fetchTimeline ({ (result: Result<[Tweet]>) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.loading = false
                if let error = result.error {
                    let alertController = ConnectionAlert.Error(message: error.description).alertController
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return
                }
                
                if let tweets = result.value {
                    self.tweets += tweets
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView?.reloadData()
                    })
                }
            }, sinceID:sinceID)
        })
    }
}
