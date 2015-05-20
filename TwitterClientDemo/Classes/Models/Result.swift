//
//  Result.swift
//  TwitterClientDemo
//
//  Created by Yusuke Kita on 5/20/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(Box<T>)
    case Failure(NSError)
    
    init(_ value: T) {
        self = .Success(Box(value))
    }
    
    init(_ error: NSError) {
        self = .Failure(error)
    }
    
    public var value: T? {
        switch self {
        case .Success(let box):
            return box.unbox
        case .Failure:
            return nil
        }
    }
    
    public var error: NSError? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}

public class Box<T> {
    let unbox: T
    init(_ value: T) { self.unbox = value }
}