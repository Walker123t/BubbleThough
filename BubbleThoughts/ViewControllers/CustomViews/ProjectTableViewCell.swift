//
//  ProjectTableViewCell.swift
//  BubbleThoughts
//
//  Created by Trevor Walker on 7/29/19.
//  Copyright © 2019 Trevor Walker. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var lastEditDateLabel: UILabel!
    
    override func prepareForReuse() {
        projectNameLabel.text = ""
        lastEditDateLabel.text = ""
    }
}
