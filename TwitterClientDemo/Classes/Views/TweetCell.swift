//
//  TweetCell.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var screenNameLable: UILabel?
    @IBOutlet weak var tweetLabel: UILabel?
    private var imageCache = NSCache()
    private var queue = NSOperationQueue()
    
    internal func setup(tweet: Tweet) {
        if let user = UserStore.sharedStore.currentUser {
            let userViewModel = UserViewModel(user: user)
            nameLabel?.text = user.name
            screenNameLable?.text = userViewModel.screenName
            tweetLabel?.text = tweet.text
            
            // use image on cache, if no exists, fetch and store it on cache
            if let image = imageCache.objectForKey(user) as? UIImage {
                profileImageView?.image = image
            } else {
                let request = NSURLRequest(URL: NSURL(string: user.profileImage)!)
                NSURLConnection.sendAsynchronousRequest(request,
                    queue: queue,
                    completionHandler: { [unowned self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        if let image = UIImage(data: data) {
                            self.imageCache.setObject(image, forKey: user)
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
        }
    }
}
