//
//  AlertStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation
import UIKit

enum LoginAlert {
    case Success(name: String, completionHandler: () -> Void)
    case Failure
    
    var alertController: UIAlertController {
        let alertController: UIAlertController
        let alertAction: UIAlertAction
        switch self {
        case .Success(let name, let completionHandler):
            alertController = UIAlertController(title: "Success", message: "Welcome \(name)!", preferredStyle: .Alert)
            alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
                completionHandler()
            })
        case .Failure:
            alertController = UIAlertController(title: "Error", message: "Please configure your twitter account in Setting", preferredStyle: .Alert)
            alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            })
        }
        alertController.addAction(alertAction)
        return alertController
    }
}