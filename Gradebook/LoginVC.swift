//
//  LoginVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: CustomButton!
    @IBOutlet weak var udacityButton: CustomButton!
    @IBOutlet weak var signInButton: CustomButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    let ref = Firebase(url: Constants.FIREBASE_URL)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
    }
    
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

    // MARK - Actions
    
    @IBAction func singUpPresed(sender: AnyObject) {
        
        let ref = Firebase()
        if let email = getEmail(), let password = getPassword() {
            
            ref.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                
                if error != nil {
                    if error.code == -9 {
                        self.sendAlert("An account for this email already exists.")
                    } else if  error.code == -15 {
                        self.sendAlert("There is a problem with the Internet connection. Try again later.")
                    } else {
                        self.sendAlert("There was a problem creating the account.")
                    }
                } else {
                    let uid = result["uid"]
                    print("Account succesfully created with uid: \(uid)")
                    self.performSegueWithIdentifier("goToClassesList", sender: nil)
                }
                
            })
        } else {
            sendAlert("Please enter an email and paasword in order to create an account.")
        }
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        setUIEnabled(false)
        if let email = getEmail(), let password = getPassword() {
            FirebaseClient.sharedInstance().attemptLogin(email, password: password, completionHandler: { (success, error) in
                
                if error != nil {
                    performUpdatesOnMain({ 
                        self.sendAlert(error!)
                    })
                } else {
                    performUpdatesOnMain({
                        self.setUIEnabled(true)
                        self.performSegueWithIdentifier("goToClassesList", sender: nil)
                    })
                }
            })
        }
        
    }
    
    @IBAction func udacityLoginPressed(sender: AnyObject) {
        if let email = getEmail(), let password = getPassword() {
            UdacityCient.sharedInstance().authenticateUser(email, password: password, completionHandlerForLogin: { (success, error) in
                
                if error != nil {
                    performUpdatesOnMain({ 
                        self.sendAlert(error!)
                    })
                } else {
                    performUpdatesOnMain({ 
                        self.performSegueWithIdentifier("goToClassesList", sender: nil)
                    })
                    
                }
            })
        }
    }
    
    @IBAction func facebookLoginPressed(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
            
            if error != nil {
                print("Failed to login with Facebbok")
            } else if result.isCancelled {
                print("Facebook login was cancelled")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Got Facebook token: \(accessToken)")
                self.ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, data) in
                    
                    if error != nil {
                        print("Error logging in")
                    } else {
                        //print("Got data: \(data)")
                        self.performSegueWithIdentifier("goToClassesList", sender: nil)
                    }
                    
                })
            }
        }
    }

}
