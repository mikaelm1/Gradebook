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
    
    let ref = Firebase(url: Constants.FIREBASE_URL)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func singUpPresed(sender: AnyObject) {
    }
    @IBAction func signInPressed(sender: AnyObject) {
        performSegueWithIdentifier("goToClassesList", sender: nil)
        
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
