//
//  LoginVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: CustomButton!
    @IBOutlet weak var udacityButton: CustomButton!
    @IBOutlet weak var signInButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
        subscribeToKeyboardNotifications()
        //emailField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    // MARK: - UI Methods
    
    func setUIEnabled(enabled: Bool) {
        signUpButton.enabled = enabled
        facebookButton.enabled = enabled
        udacityButton.enabled = enabled
        signInButton.enabled = enabled
        passwordField.enabled = enabled
        emailField.enabled = enabled
        
        if enabled {
            signUpButton.alpha = 1.0
            facebookButton.alpha = 1.0
            udacityButton.alpha = 1.0
            signInButton.alpha = 1.0
            passwordField.alpha = 1.0
            emailField.alpha = 1.0
            
            showActivity(false)
        } else {
            signUpButton.alpha = 0.5
            facebookButton.alpha = 0.5
            udacityButton.alpha = 0.5
            signInButton.alpha = 0.5
            passwordField.alpha = 0.5
            emailField.alpha = 0.5
            
            showActivity(true)
        }
    }
    
    func showActivity(state: Bool) {
        if state {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.hidden = true 
            activityIndicator.stopAnimating()
        }
    }
    
    func sendAlert(message: String) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            self.emailField.becomeFirstResponder()
        }))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func getEmail() -> String? {
        if let email = emailField.text where email != "" {
            return email
        }
        return nil
    }
    
    func getPassword() -> String? {
        if let password = passwordField.text where password != "" {
            return password
        }
        return nil
    }
    
    func goToCoursesFor(student: Student) {
        eraseTextFields()
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CoursesTableVC") as! CoursesTableVC
        vc.student = student
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func eraseTextFields() {
        emailField.text = ""
        passwordField.text = ""
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Fetch Request
    
    func executeFetchForUser(username: String) -> [Student] {
        let fetchRequest = NSFetchRequest(entityName: "Student")
        do {
            return try CoreDataStackManager.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as! [Student]
        } catch {
            return [Student]()
        }
    }
    
    func getStudent(username: String) -> Student {
        let students = executeFetchForUser(username)
        print("Count of Students: \(students.count)")
        
        if students.count >= 0 {
            for student in students {
                if student.username == username {
                    return student
                }
            }
        }
        return createStudent(username)
    }
    
    func createStudent(username: String) -> Student {
        let student = Student(username: username, context: sharedContext, courses: nil)
        CoreDataStackManager.sharedInstance().saveContext()
        return student
    }

    // MARK: - Actions
    
    @IBAction func singUpPresed(sender: AnyObject) {
     
        
        if let email = getEmail(), let password = getPassword() {
            setUIEnabled(false)
            FirebaseClient.sharedInstance().createUser(email, password: password, completionHandler: { (success, error) in
                
                if error != nil {
                    performUpdatesOnMain({ 
                        self.sendAlert(error!)
                        self.setUIEnabled(true)
                    })
                } else {
                    performUpdatesOnMain({ 
                        self.setUIEnabled(true)
                        let student = self.getStudent(email)
                        self.goToCoursesFor(student)
                    })
                }
            })
        } else {
            sendAlert("Please enter an email and password in order to sign up.")
        }
        
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        setUIEnabled(false)
        if let email = getEmail(), let password = getPassword() {
            FirebaseClient.sharedInstance().attemptLogin(email, password: password, completionHandler: { (success, error) in
                
                if error != nil {
                    performUpdatesOnMain({ 
                        self.sendAlert(error!)
                        self.setUIEnabled(true)
                    })
                } else {
                    performUpdatesOnMain({
                        self.setUIEnabled(true)
                        // TODO Fix this!!! Only here for testing!!!
                        let student = self.getStudent(email)
                        self.goToCoursesFor(student)
                    })
                }
            })
        } else {
            setUIEnabled(true)
            sendAlert("Please enter an email and password to sign in.")
        }
        
    }
    
    @IBAction func udacityLoginPressed(sender: AnyObject) {
        setUIEnabled(false)
        if let email = getEmail(), let password = getPassword() {
            UdacityCient.sharedInstance().authenticateUser(email, password: password, completionHandlerForLogin: { (success, error) in
                
                if error != nil {
                    performUpdatesOnMain({ 
                        self.sendAlert(error!)
                    })
                } else {
                    performUpdatesOnMain({
                        self.setUIEnabled(true)
                        let student = self.getStudent(email)
                        self.goToCoursesFor(student)
                    })
                    
                }
            })
        } else {
            setUIEnabled(true)
            sendAlert("Please enter an email and password to sign in.")
        }
    }
    
    @IBAction func facebookLoginPressed(sender: AnyObject) {
        setUIEnabled(false)
        
        FirebaseClient.sharedInstance().attemptFacebookLogin(self) { (success, result, error) in
            
            if error != nil {
                performUpdatesOnMain({ 
                    self.sendAlert(error!)
                })
            } else if success {
                let email = result!["email"] as! String
                print("Email: \(email)")
                performUpdatesOnMain({
                    self.setUIEnabled(true)
                    let student = self.getStudent(email)
                    self.goToCoursesFor(student)
                })
            } else {
                print("Something weird has happened")
            }
        }
    }
    
    // MARK: TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will Show")
        topConstraint.constant = 10
        print("View Y: \(topConstraint.constant)")
        
    }
    
    func keyboardWillHide() {
        print("Keyboard will Hide")
        topConstraint.constant = 100
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        //print("User Info: \(userInfo)")
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

}




