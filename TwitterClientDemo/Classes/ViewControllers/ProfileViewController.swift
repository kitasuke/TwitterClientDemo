//
//  ProfileViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var ProfileDetailView: UIView?
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        self.navigationItem.title = UserStore.sharedStore.currentUser?.name
    }
}
