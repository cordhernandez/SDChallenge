//
//  NSOperation+.swift
//  SDTestMusic
//
//  Created by Cordero Hernandez on 9/23/17.
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation

class Operation {
    
    static let instance = Operation()
    private init() {}
    
    let main = OperationQueue.main
    
    let async: OperationQueue = {
        
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        
        return operationQueue
    }()
}


