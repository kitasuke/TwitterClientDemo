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
    
    private var comments = [Comment]()
    
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(comments)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.text
        return cell
    }
    
    // MARK: - Gesture handler
    
    internal func postComment(recognizer: UITapGestureRecognizer) {
        if let text = postingView?.textView?.text {
            let trimmedText = self.condenseWhitespace(text)
            if count(trimmedText) > 0 {
                self.comment(trimmedText)
                self.replyWithDelay(trimmedText)

                postingView?.cleanup()
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
        postingView?.setup()
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
    
    // MARK: - Comment operator
    
    private func comment(text: String) {
        CommentStore.sharedStore.comment(text, completionHandler: { [unowned self] (result: Result<Comment>) -> Void in
            if let comment = result.value {
                self.showComment(comment)
            }
        })
    }
    
    private func replyWithDelay(text: String) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            CommentStore.sharedStore.reply(text + text, user: UserStore.sharedStore.currentUser!, completionHandler: { [unowned self] (result: Result<Comment>) -> Void in
                if let comment = result.value {
                    self.showComment(comment)
                }
            })
        })
    }
    
    private func showComment(comment: Comment) {
        self.comments.append(comment)
        self.tableView?.reloadData()
    }
}
