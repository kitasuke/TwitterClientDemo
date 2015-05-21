//
//  UserCell.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var screenLabel: UILabel?
    
    internal func setup(row: Int, user: User) {
        nameLabel?.text = user.name
        nameLabel?.tag = row
        screenLabel?.text = "@" + user.screenName
        screenLabel?.tag = row
        if let imageURL = NSURL(string: user.profileImage), let imageData = NSData(contentsOfURL: imageURL) {
            profileImageView?.image = UIImage(data: imageData)
        }
        profileImageView?.tag = row
        self.accessoryType = user.following == true ? .Checkmark : .None
    }
}