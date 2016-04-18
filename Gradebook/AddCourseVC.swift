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

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var courseNameField: UITextField!
    
    var student: Student!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseNameField.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        courseNameField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Text Field Delegate 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Keyboard Methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddCourseVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddCourseVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        topConstraint.constant = 50
        
    }
    
    func keyboardWillHide() {
        topConstraint.constant = 200
    }

    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let courseName = courseNameField.text
        let course = Course(name: courseName!, context: sharedContext, assignments: nil)
        course.student = student 
        CoreDataStackManager.sharedInstance().saveContext()
        
        navigationController?.popViewControllerAnimated(true)
    }

}
