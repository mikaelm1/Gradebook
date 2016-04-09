//
//  CourseDetailCell.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/4/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class CourseDetailCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var assignmentNameLabel: UILabel!
    @IBOutlet weak var assignmentGradeLabel: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 5.0
        cellView.clipsToBounds = true
        
        assignmentNameLabel.textColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
