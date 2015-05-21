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
        self.fetchMe()
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
            cell.setup(indexPath.row, user: user)
            self.registerGestureRecognizers(cell)
            return cell
        case Section.Loading.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellName.Indicator.rawValue, forIndexPath: indexPath) as! IndicatorCell
            cell.start()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Gesture handler
    
    internal func openMessageView(recognizer: UITapGestureRecognizer) {
        if let row = recognizer.view?.tag {
            let user = users[row]
            UserStore.sharedStore.currentUser = user
            let messageViewController = UIStoryboard(name: StoryboardName.Message.rawValue, bundle: nil).instantiateInitialViewController() as! MessageViewController
            self.navigationController?.pushViewController(messageViewController, animated: true)
        }
    }
    
    internal func openProfileView(recognizer: UITapGestureRecognizer) {
        if let row = recognizer.view?.tag {
            let user = users[row]
            UserStore.sharedStore.currentUser = user
            let profileViewController = UIStoryboard(name: StoryboardName.Profile.rawValue, bundle: nil).instantiateInitialViewController() as! ProfileViewController
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        self.tableView?.estimatedRowHeight = CellHeightUser
        
        let userCellName = CellName.User.rawValue
        self.tableView?.registerNib(UINib(nibName: userCellName, bundle: nil), forCellReuseIdentifier: userCellName)
        let indicatorCellName = CellName.Indicator.rawValue
        self.tableView?.registerNib(UINib(nibName: indicatorCellName, bundle: nil), forCellReuseIdentifier: indicatorCellName)
    }
    
    private func registerGestureRecognizers(cell: UserCell) {
        let selector = Selector("openMessageView:")
        cell.nameLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        cell.screenLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
        cell.profileImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("openProfileView:")))
    }
    
    // MARK: - Fetcher
    
    private func fetchFollowersList() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
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
    
    private func fetchMe() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            TwitterStore.sharedStore.fetchMe({ (result: Result<User>) -> Void in
                // TODO
            })
        })
    }
}

