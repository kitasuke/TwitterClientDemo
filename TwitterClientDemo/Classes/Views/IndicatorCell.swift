//
//  IndicatorCell.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class IndicatorCell: UITableViewCell {
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    internal func start() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            indicator?.startAnimating()
        })
    }
    
    internal func stop() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            indicator?.stopAnimating()
        })
    }
}