//
//  CommentCell.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentView: UIView?
    @IBOutlet weak var backgroundImageView: UIImageView?
    @IBOutlet weak var commentLabel: UILabel?
    
    internal func setup(comment: Comment) {
        commentLabel?.text = comment.text
    }
}
