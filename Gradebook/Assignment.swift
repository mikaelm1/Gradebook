//
//  Assignment.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class Assignment: NSManagedObject {
    
    @NSManaged var assignmentTitle: String
    @NSManaged var assignmentDescription: String
    @NSManaged var gradeWeight: Double
    @NSManaged var course: Course
    @NSManaged var gradeValue: Double
    @NSManaged var gradeLetter: String
    @NSManaged var gradeScore: Double

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(assignmentTitle: String, gradeWeight: Double, gradeValue: Double, gradeLetter: String, context: NSManagedObjectContext, assignmentDescription: String, gradeScore: Double) {
        
        let entity = NSEntityDescription.entityForName("Assignment", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.assignmentTitle = assignmentTitle
        self.gradeWeight = gradeWeight
        self.gradeValue = gradeValue
        self.gradeLetter = gradeLetter
        self.assignmentDescription = assignmentDescription
        self.gradeScore = gradeScore 
    }
    
}



