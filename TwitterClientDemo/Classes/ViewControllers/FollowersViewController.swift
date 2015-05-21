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
    private var paginator = Paginator()
    private let CellHeightUser: CGFloat = 64
    private let CellHeightLoading: CGFloat = 44
    
    private enum Section: Int {
        case Indicator = 0
        case Contents = 1
        case Loading = 2
    }

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
        return 3 // Indicator + Contents + Loading
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.Indicator.rawValue:
            return count(users) > 0 ? 0 : 1 // show indicator if no contents
        case Section.Contents.rawValue:
            return count(users)
        case Section.Loading.rawValue:
            return paginator.hasNext ? 1 : 0 // show loading more if contents has more
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.Indicator.rawValue:
            return CGRectGetHeight(tableView.frame)
        case Section.Contents.rawValue:
            return CellHeightUser
        case Section.Loading.rawValue:
            return CellHeightLoading
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.Indicator.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellName.Indicator.rawValue, forIndexPath: indexPath) as! IndicatorCell
            return cell
        case Section.Contents.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellName.User.rawValue, forIndexPath: indexPath) as! UserCell
            let user = users[indexPath.row]
            cell.setup(user)
            return cell
        case Section.Loading.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellName.Indicator.rawValue, forIndexPath: indexPath) as! IndicatorCell
            cell.start()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Constructor
    
    private func setupTableView() {
        self.tableView?.estimatedRowHeight = CellHeightUser
        
        let userCellName = CellName.User.rawValue
        self.tableView?.registerNib(UINib(nibName: userCellName, bundle: nil), forCellReuseIdentifier: userCellName)
        let indicatorCellName = CellName.Indicator.rawValue
        self.tableView?.registerNib(UINib(nibName: indicatorCellName, bundle: nil), forCellReuseIdentifier: indicatorCellName)
    }
    
    // MARK: - Fetcher
    
    private func fetchFollowersList() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            TwitterStore.sharedStore.fetchFollowers { [unowned self] (result: Result<[String: AnyObject]>) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let error = result.error {
                    return
                }
                
                if let values = result.value {
                    self.users = values["users"] as! [User]
                    self.paginator = values["paginator"] as! Paginator
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView?.reloadData()
                    })
                }
            }
        })
    }
}
