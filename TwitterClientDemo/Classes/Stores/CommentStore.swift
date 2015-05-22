//
//  CommentStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit
import CoreData

class CommentStore {
    static let sharedStore = CommentStore()
    
    // MARK: - API call
    
    internal func fetchComments() -> [Comment] {
        var comments: [Comment] = []
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = delegate.managedObjectContext {
            if let entityDescription = NSEntityDescription.entityForName("Comment", inManagedObjectContext: managedObjectContext) {
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = entityDescription
                
                if let currentUsername = UserStore.sharedStore.currentUser?.screenName {
                    let predicate = NSPredicate(format: "username = %@ or replyTo = %@", currentUsername, currentUsername)
                    fetchRequest.predicate = predicate
                    
                    var error: NSError?
                    if let results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Comment] {
                        comments = results
//                        comments.sort { $0.createdAt < $1.createdAt } // TODO
                    }
                }
            }
        }
        return comments
    }
    
    internal func comment(text: String, completionHandler: (Result<Comment>) -> Void) {
        // TODO
        if let me = UserStore.sharedStore.me, user = UserStore.sharedStore.currentUser {
             self.addComment(text, username: me.screenName, replyTo: user.screenName, completionHandler: completionHandler)
        }
    }
    
    internal func reply(text: String, user: User, completionHandler: (Result<Comment>) -> Void) {
        // TODO
        if let user = UserStore.sharedStore.currentUser, me = UserStore.sharedStore.me {
            self.addComment(text, username: user.screenName, replyTo: me.screenName, completionHandler: completionHandler)
        }
    }
    
    private func addComment(text: String, username: String, replyTo: String, completionHandler: (Result<Comment>) -> Void) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = delegate.managedObjectContext {
            let comment = NSEntityDescription.insertNewObjectForEntityForName("Comment", inManagedObjectContext: managedObjectContext) as! TwitterClientDemo.Comment
            comment.text = text
            comment.username = username
            comment.replyTo = replyTo
            comment.createdAt = NSDate()
            delegate.saveContext()
            completionHandler(Result(comment))
        }
    }
}