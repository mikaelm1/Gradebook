//
//  Class.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class Course: NSManagedObject {
    
    enum Grade: Double {
        case A = 4.0
        case AMinus = 3.7
        case BPlus = 3.3
        case B = 3.0
        case BMinus = 2.7
        case CPlus = 2.3
        case C = 2.0
        case CMinus = 1.7
        case DPlus = 1.3
        case D = 1.0
        case DMinus = 0.7
        case F = 0
    }
    
    @NSManaged var name: String
    @NSManaged var assignments: NSSet?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, assignments: [Assignment]?, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
    
}




