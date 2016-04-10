//
//  CourseGradeVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/10/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class CourseGradeVC: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.text = "\(course.assignments?.count)"
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
