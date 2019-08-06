//
//  textField.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 8/5/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit

extension UITextField {
    func designed(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        border.bounds = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.textColor = UIColor(red:0.05, green:0.05, blue:0.05, alpha:0.75)
    }
}
