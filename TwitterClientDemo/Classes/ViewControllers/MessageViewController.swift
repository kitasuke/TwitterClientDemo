//
//  MessageViewController.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var postingView: PostingView?
    @IBOutlet weak var postingViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupPostingView()
        self.addKeyboardObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.removeKeyboardObserver()
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - Gesture handler
    
    internal func postComment(recognizer: UITapGestureRecognizer) {
        if let text = postingView?.textField?.text {
            let trimmedText = self.condenseWhitespace(text)
            if count(trimmedText) > 0 {
                CommentStore.sharedStore.comment(trimmedText)
                self.postingView?.textField?.endEditing(true)
                self.postingView?.textField?.text = ""
            }
        }
    }
    
    // MARK: - NSNotificationCenter
    
    internal func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        if let startFrame = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue(), let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() {
            
            // calculate keyboard height to set bottom constant properly
            let keyboardHeight: CGFloat
            if CGRectGetMinY(startFrame) < CGRectGetMaxY(self.view.frame) {
                keyboardHeight = CGRectGetHeight(endFrame) - CGRectGetHeight(startFrame)
            } else {
                keyboardHeight = CGRectGetHeight(startFrame)
            }
            self.postingViewBottomConstraint?.constant += keyboardHeight
            
            self.animateKeyboard(userInfo)
        }
    }
    
    internal func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        self.postingViewBottomConstraint?.constant = 0
        
        self.animateKeyboard(userInfo)
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        if let user = UserStore.sharedStore.currentUser {
            let userViewModel = UserViewModel(user: user)
            self.navigationItem.title = userViewModel.screenName
        }
    }
    
    private func setupPostingView() {
        postingView?.postButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("postComment:")))
    }
    
    private func addKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: - Animation operator
    
    private func animateKeyboard(userInfo: [String: AnyObject]) {
        UIView.animateWithDuration((userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue,
            delay: 0,
            options: UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16)),
            animations: { [unowned self] () -> Void in
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - String operator
    
    private func condenseWhitespace(string: String) -> String {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
        return join(" ", components)
    }
}
