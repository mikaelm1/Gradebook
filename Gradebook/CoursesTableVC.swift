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
    
    var student: Student! 
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Course")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "student == %@", self.student)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpToolbar()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
        
    }
    
    func setUpUI() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CoursesTableVC.addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(CoursesTableVC.logout))
        self.navigationItem.leftBarButtonItem = logoutButton
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        self.title = "Courses"
        
    }
    
    func setUpToolbar() {
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar?.barTintColor = Constants.SPECIAL_BLUE_COLOR
        navigationController?.toolbar.tintColor = UIColor.whiteColor()
    }
    
    func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constants.LAST_LOGGED_IN)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func addButtonPressed() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AddCourseVC") as! AddCourseVC
        vc.student = student
        navigationController?.pushViewController(vc, animated: true)
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
        
        let course = fetchedResultsController.objectAtIndexPath(indexPath) as! Course
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell") as! CourseCell
        configureCell(cell, course: course)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! CourseCell
            let course = controller.objectAtIndexPath(indexPath!) as! Course
            configureCell(cell, course: course)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func configureCell(cell: CourseCell, course: Course) {
        cell.courseNameLabel.text = course.name
    }

}















