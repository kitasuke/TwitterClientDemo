//
//  PostingView.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/21/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class PostingView: UIView, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var postButton: UIButton?
    @IBOutlet weak var postingViewHeightConstraint: NSLayoutConstraint?

    var lastTextSize: CGSize!
    private let lineHeight: CGFloat = 23 // TODO
    
    // MARK: - Setup
    
    internal func setup() {
        textView?.delegate = self
        lastTextSize = self.calculateTextSize("")
    }
    
    internal func cleanup() {
        textView?.endEditing(true)
        textView?.text = ""
        postingViewHeightConstraint?.constant = 48
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText: String
        if range.length == 1 {
            newText = textView.text.substringToIndex(advance(textView.text.endIndex, -1))
        } else {
            newText = textView.text + text
        }
        let textSize = self.calculateTextSize(newText)
        
        if text == "\n" { // if return pressed
            self.addLine()
            lastTextSize = textSize
            return true
        }
        
        if self.shouldChangeLine(textSize) {
            self.changeLine(textSize)
        }
        lastTextSize = textSize
        return true
    }
    
    // MARK: - Line manager
    
    private func shouldChangeLine(newTextSize: CGSize) -> Bool {
        if lastTextSize?.height == newTextSize.height {
            return false
        }
        return true
    }
    
    private func changeLine(newTextSize: CGSize) {
        if lastTextSize?.height < newTextSize.height {
            self.addLine()
        } else {
            self.subtractLine()
        }
    }
    
    private func addLine() {
        postingViewHeightConstraint?.constant += lineHeight
    }
    
    private func subtractLine() {
        postingViewHeightConstraint?.constant -= lineHeight
    }
    
    // MARK: - Text size calculator
    
    private func calculateTextSize(text: String) -> CGSize {
        return NSString(string: text).boundingRectWithSize(CGSizeMake(CGRectGetWidth(textView!.frame), 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: textView!.font], context: nil).size
    }
}
