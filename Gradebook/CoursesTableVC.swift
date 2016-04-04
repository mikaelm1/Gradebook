//
//  ClassesTableVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class CoursesTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Course")
        fetchRequest.sortDescriptors = []
        //print("FetchRequest; \(fetchRequest)")
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fethc")
        }
        
    }
    
    func setUpUI() {
        print("Setting up UI")
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CoursesTableVC.addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        self.title = "Classes"
    }

    func addButtonPressed() {
        print("Add button pressed")
        performSegueWithIdentifier("AddClass", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCourseDetail" {
            print("Prepared for segueue")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let course = fetchedResultsController.objectAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell") as! CourseCell
        
        cell.courseNameLabel.text = course.name 


        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell at index \(indexPath)")
        let course = fetchedResultsController.objectAtIndexPath(indexPath) as! Course
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CourseDetailTableVC") as! CourseDetailTableVC
        vc.course = course
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            print("Inserted section")
        case .Delete:
            print("Deleted section")
        default:
            print("Section was changed in default switch case")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            let course = controller.objectAtIndexPath(indexPath!)
            // TODO: configure the cell with the new course 
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }

}















