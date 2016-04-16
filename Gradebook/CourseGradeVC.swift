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
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    @IBOutlet weak var totalPossiblePointsLabel: UILabel!
    @IBOutlet weak var percentageCompleted: UILabel! 
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let grade = calculateGrade()
        letterGradeLabel.text = "Grade: \(grade.0)"
        pointsEarnedLabel.text = "Points Earned: \(grade.1)"
        totalPossiblePointsLabel.text = "Total Possible Points: \(grade.2)"
        percentageCompleted.text = "Percent of course completed: \(grade.2)%"
    }
    
    func calculateGrade() -> (String, Int, Int) {
        let assignments = getAssignments()
        var score: Double = 0
        var total: Double = 0
        for i in assignments {
            score += (i.gradeScore * i.gradeWeight)
            total += i.gradeWeight
        }
        let points = calculatePointsEarned(assignments)
        score = (score / total)
        print("Score: \(score)")
        let grade = gradeLetterFromScore(score)

        return (grade, points, Int(total))
    }
    
    func calculatePointsEarned(assignments: [Assignment]) -> Int {
        var points: Double = 0
        for i in assignments {
            let assignmentPoints = (i.gradeScore/100) * i.gradeWeight
            points += assignmentPoints
        }
        return Int(points)
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
