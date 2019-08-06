//
//  Array.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 8/1/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
}
