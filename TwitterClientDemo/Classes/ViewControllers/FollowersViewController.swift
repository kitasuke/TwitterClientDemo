//
//  FollowersViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    private var users = [User]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupTableView()
        
        self.fetchFollowersList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(users)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellName.User.rawValue, forIndexPath: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.setup(user)
        return cell
    }
    
    // MARK: - Constructor
    
    private func setupTableView() {
        self.tableView?.rowHeight = 65
        
        let userCellName = CellName.User.rawValue
        self.tableView?.registerNib(UINib(nibName: userCellName, bundle: nil), forCellReuseIdentifier: userCellName)
    }
    
    // MARK: - Fetcher
    
    private func fetchFollowersList() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            TwitterStore.sharedStore.fetchFollowers { [unowned self] (result: Result<[String: AnyObject]>) -> Void in
                if let error = result.error {
                    return
                }
                
                if let values = result.value {
                    self.users = values["users"] as! [User]
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView?.reloadData()
                    })
                }
            }
        })
    }
}

