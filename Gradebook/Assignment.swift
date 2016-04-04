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
    
    @NSManaged var assignmentDescription: String
    @NSManaged var gradeWeight: Double
    @NSManaged var course: Course
    @NSManaged var grade: Double

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(assignmentDescription: String, gradeWeight: Double, grade: Double, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Assignment", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.assignmentDescription = assignmentDescription
        self.gradeWeight = gradeWeight
        self.grade = grade 
    }
    
}



