//
//  MessageViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var postingView: PostingView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupPostingView()
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - Gesture handler
    
    internal func postComment(recognizer: UITapGestureRecognizer) {
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        if let user = UserStore.sharedStore.currentUser {
            let userViewModel = UserViewModel(user: user)
            self.navigationItem.title = userViewModel.screenName
        }
    }
    
    private func setupPostingView() {
        postingView?.postButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("postComment:")))
    }
}
