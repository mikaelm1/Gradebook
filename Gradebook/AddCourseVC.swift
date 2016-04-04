//
//  AddClassVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class AddCourseVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var courseNameField: UITextField!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseNameField.delegate = self

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AddCourseVC.cancelButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func cancelButtonPressed() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Text Field Delegate 
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("Did begin editing")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("Did end editing")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let courseName = courseNameField.text
        _ = Course(name: courseName!, context: sharedContext, assignments: nil)
        
        CoreDataStackManager.sharedInstance().saveContext()
        
        navigationController?.popViewControllerAnimated(true)
    }

}
