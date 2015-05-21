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
    private var imageCache = NSCache()
    private var queue = NSOperationQueue()
    
    internal func setup(row: Int, user: User) {
        nameLabel?.text = user.name
        nameLabel?.tag = row
        let userViewModel = UserViewModel(user: user)
        screenLabel?.text = userViewModel.screenName
        screenLabel?.tag = row
        
        // use image on cache, if no exists, fetch and store it on cache
        if let image = imageCache.objectForKey(row) as? UIImage {
            profileImageView?.image = image
        } else {
            let request = NSURLRequest(URL: NSURL(string: user.profileImage)!)
            NSURLConnection.sendAsynchronousRequest(request,
                queue: queue,
                completionHandler: { [unowned self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: row)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.profileImageView?.image = image
                            self.profileImageView?.alpha = 0
                            UIView.animateWithDuration(1.0, animations: { () -> Void in // like SDWebImage
                                self.profileImageView?.alpha = 1
                            })
                        })
                    }
            })
        }
        profileImageView?.tag = row
        self.accessoryType = user.following == true ? .Checkmark : .None
    }
}