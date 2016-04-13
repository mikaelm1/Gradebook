//
//  ClassDetailTableVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class CourseDetailTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var noAssignmentsView: UIView!
    
    var course: Course!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Assignment")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "course == %@", self.course)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to fetch Assignment")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        setUpUI()
        tableView.reloadData()
        checkForAssignments()
    }
    
    func showGrade() {
        
    }
    
    func checkForAssignments() {
        if course.assignments?.count == 0 {
            noAssignmentsView.hidden = false
        } else {
            noAssignmentsView.hidden = true
        }
    }
    
    func setUpUI() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CourseDetailTableVC.addAssignment))
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        title = course.name
    }
    
    func addAssignment() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AssignmentVC") as! AssignmentVC
        vc.course = course 
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        print("Assignment: \(assignment)")
        let cell = tableView.dequeueReusableCellWithIdentifier("ClassDetailCell", forIndexPath: indexPath) as! CourseDetailCell 
        configureCell(cell, assignment: assignment)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected cell at row \(indexPath.row)")
        
        let assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AssignmentVC") as! AssignmentVC
        vc.course = course
        vc.assignment = assignment
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
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! CourseDetailCell
            let assignment = controller.objectAtIndexPath(indexPath!) as! Assignment
            configureCell(cell, assignment: assignment)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK - Configure Cell
    
    func configureCell(cell: CourseDetailCell, assignment: Assignment) {
        cell.assignmentNameLabel.text = assignment.assignmentTitle
        cell.assignmentGradeLabel.text = "\(assignment.gradeLetter)"
    }

    @IBAction func viewGradePressed(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CourseGradeVC") as! CourseGradeVC
        vc.course = course
        navigationController?.pushViewController(vc, animated: true)
    }

}
