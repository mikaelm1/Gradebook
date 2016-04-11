//
//  CourseGradeVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/10/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class CourseGradeVC: UIViewController {

    @IBOutlet weak var letterGradeLabel: UILabel!
    @IBOutlet weak var scoreOutOfTotalLabel: UILabel!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        let grade = calculateGrade()
        letterGradeLabel.text = "\(grade.0)"
        scoreOutOfTotalLabel.text = "\(grade.1)"
    }
    
    func calculateGrade() -> (String, Double) {
        let assignments = getAssignments()
        var score: Double = 0
        var total: Double = 0
        for i in assignments {
            score += (i.gradeScore * i.gradeWeight)
            total += i.gradeWeight
        }
        score = (score / total)
        print("Score: \(score)")
        let grade = gradeLetterFromScore(score)

        return (grade, total)
    }
    
    func getAssignments() -> [Assignment] {
        var assignments = [Assignment]()
        if course.assignments?.count > 0 {
            for i in course.assignments! {
                assignments.append(i as! Assignment)
            }
        }
        return assignments
    }

    func gradeLetterFromScore(score: Double) -> String {
        switch score {
        case 93...100:
            return Grade.GradeLetter.A.rawValue
        case 90..<93:
            return Grade.GradeLetter.AMinus.rawValue
        case 87..<90:
            return Grade.GradeLetter.BPlus.rawValue
        case 83..<87:
            return Grade.GradeLetter.B.rawValue
        case 80..<83:
            return Grade.GradeLetter.BMinus.rawValue
        case 77..<80:
            return Grade.GradeLetter.CPlus.rawValue
        case 73..<77:
            return Grade.GradeLetter.C.rawValue
        case 70..<73:
            return Grade.GradeLetter.CMinus.rawValue
        case 67..<70:
            return Grade.GradeLetter.DPlus.rawValue
        case 63..<67:
            return Grade.GradeLetter.D.rawValue
        case 60..<63:
            return Grade.GradeLetter.DMinus.rawValue
        default:
            return Grade.GradeLetter.F.rawValue 
        }
    }


}
