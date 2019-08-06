//
//  Bubble.swift
//  BubbleThoughts
//  Created by Trevor Walker on 7/29/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import Foundation
class Bubble{
    
    var lastChanged: Date
    var projectName: String
    var bubbles: [String]{
        didSet{
            lastChanged = Date()
        }
    }
    var uid: String
    var users: [String]
    
    init(lastChanged: Date, projectName: String, bubbles: [String], users: [String], uid: String = UUID().uuidString) {
        self.lastChanged = lastChanged
        self.projectName = projectName
        self.bubbles = bubbles
        self.users = users
        self.uid = uid
    }
}

extension Bubble: Equatable{
    static func == (lhs: Bubble, rhs: Bubble) -> Bool {
        if lhs.lastChanged == rhs.lastChanged &&
            lhs.projectName == rhs.projectName &&
            lhs.bubbles == rhs.bubbles &&
            lhs.users == rhs.users {
            return true
        }
        return false
    }
}
