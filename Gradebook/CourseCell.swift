//
//  CourseCell.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/4/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {
    
    
    @IBOutlet weak var courseView: UIView!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        courseView.layer.cornerRadius = 5.0
        courseView.clipsToBounds = true 
    }
    
}
