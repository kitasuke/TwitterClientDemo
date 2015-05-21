//
//  ProfileDetailView.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class ProfileDetailView: UIView {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var screenNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var timeZoneLabel: UILabel?
    @IBOutlet weak var URLTextView: UITextView?
    @IBOutlet weak var followersCountLabel: UILabel?
    @IBOutlet weak var friendsCountLabel: UILabel?
    private var imageCache = NSCache()
    private var queue = NSOperationQueue()
    
    internal func setup() {
        if let user = UserStore.sharedStore.currentUser {
            let userViewModel = UserViewModel(user: user)
            nameLabel?.text = user.name
            screenNameLabel?.text = userViewModel.screenName
            descriptionLabel?.text = user.descriptionString
            timeZoneLabel?.text = user.timeZone
            URLTextView?.text = user.URL
            followersCountLabel?.text = userViewModel.followersCountString
            friendsCountLabel?.text = userViewModel.friendsCountString
            
            // use image on cache, if no exists, fetch and store it on cache
            if let image = imageCache.objectForKey(user) as? UIImage {
                imageView?.image = image
            } else {
                let request = NSURLRequest(URL: NSURL(string: user.profileImage)!)
                NSURLConnection.sendAsynchronousRequest(request,
                    queue: queue,
                    completionHandler: { [unowned self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        if let image = UIImage(data: data) {
                            self.imageCache.setObject(image, forKey: user)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.imageView?.image = image
                                self.imageView?.alpha = 0
                                UIView.animateWithDuration(1.0, animations: { () -> Void in // like SDWebImage
                                    self.imageView?.alpha = 1
                                })
                            })
                        }
                    })
            }
        }
    }
}
