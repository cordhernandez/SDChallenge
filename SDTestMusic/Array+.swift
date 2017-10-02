//
//  Arrays+.swift
//  SDTestMusic
//
//  Created by Cordero Hernandez on 10/2/17.
//  Copyright © 2017 SD. All rights reserved.
//

import Foundation

extension Array {
    
    var notEmpty: Bool {
        return !isEmpty
    }
    
    /**
     Tells whether the specified index is in bounds of the array.
     Use this check with indexes before accessing the array.
     */
    func isInBounds(index: Int) -> Bool {
        
        return index >= 0 && index < self.count
    }
}
