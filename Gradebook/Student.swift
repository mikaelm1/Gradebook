//
//  Student.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/13/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class Student: NSManagedObject {
    
    @NSManaged var username: String
    @NSManaged var courses: NSSet?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(username: String, context: NSManagedObjectContext, courses: [Course]?) {
        
        let entity = NSEntityDescription.entityForName("Student", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.username = username 
    }
    
}
