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
    
    internal func comment(text: String) {
        // TODO
        if let me = UserStore.sharedStore.me, user = UserStore.sharedStore.currentUser {
             self.addComment(text, user: me, replyTo: user)
        }
    }
    
    internal func reply(text: String, user: User) {
        // TODO
        if let user = UserStore.sharedStore.currentUser, me = UserStore.sharedStore.me {
            self.addComment(text, user: user, replyTo: me)
        }
    }
    
    private func addComment(text: String, user: User, replyTo: User) {
        
    }
}