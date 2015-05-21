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
    
    internal func setup(user: User) {
        nameLabel?.text = user.name
        screenLabel?.text = "@" + user.screenName
        if let imageURL = NSURL(string: user.profileImage), let imageData = NSData(contentsOfURL: imageURL) {
            profileImageView?.image = UIImage(data: imageData)
        }
        self.accessoryType = user.following == true ? .Checkmark : .None
    }
}