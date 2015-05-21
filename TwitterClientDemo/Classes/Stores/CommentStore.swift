//
//  CommentStore.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

class CommentStore {
    static let sharedStore = CommentStore()
    
    // MARK: - API call
    
    internal func comment(text: String, completionHandler: (Result<Comment>) -> Void) {
        // TODO
        if let me = UserStore.sharedStore.me, user = UserStore.sharedStore.currentUser {
             self.addComment(text, user: me, replyTo: user, completionHandler: completionHandler)
        }
    }
    
    internal func reply(text: String, user: User, completionHandler: (Result<Comment>) -> Void) {
        // TODO
        if let user = UserStore.sharedStore.currentUser, me = UserStore.sharedStore.me {
            self.addComment(text, user: user, replyTo: me, completionHandler: completionHandler)
        }
    }
    
    private func addComment(text: String, user: User, replyTo: User, completionHandler: (Result<Comment>) -> Void) {
        let comment = Comment(text: text, user: user, replyTo: replyTo)
        completionHandler(Result(comment))
    }
}