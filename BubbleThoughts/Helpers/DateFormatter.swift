//
//  DateFormatter.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 8/2/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import Foundation

extension Date{
    func formatDate() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
