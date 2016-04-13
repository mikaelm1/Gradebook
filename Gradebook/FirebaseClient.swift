//
//  Firebase.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/11/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

typealias CompletionHandler = (success: Bool, error: String?) -> Void
typealias FBCompletionHandler = (success: Bool, result: [String: AnyObject]?, error: String?) -> Void

class FirebaseClient {
    
    let ref = Firebase(url: Constants.FIREBASE_URL)
    
    func attemptFacebookLogin(viewController: UIViewController, completionHandler: FBCompletionHandler) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: viewController) { (result, error) in
            
            if error != nil {
                completionHandler(success: false, result: nil, error: "Failed to login with Facebook")
            } else if result.isCancelled {
                print("Facebook login was cancelled")
                completionHandler(success: false, result: nil, error: "Facebook login was cancelled")
            } else {
                
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString

                //print("Got Facebook token: \(accessToken)")
                self.ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, data) in
                    
                    if error != nil {
                        print("Error logging in")
                        completionHandler(success: false, result: nil, error: "There was an error logging in")
                    } else {
                        //print("Got data: \(data)")
                        self.getUserEmail(accessToken, completionHandler: completionHandler)
                    }
                    
                })
            }
        }
    }
    
    func getUserEmail(token: String, completionHandler: FBCompletionHandler) {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"], tokenString: token, version: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler({ (connection, result, error) in
            
            if error != nil {
                print("There was an error getting the user's email")
                completionHandler(success: false, result: nil, error: "There was an error getting the user's email")
            } else {
                
                guard let result = result as? [String: AnyObject] else {
                    completionHandler(success: false, result: nil, error: "Error parsing Facebook's result")
                    return 
                }
                print("FACEBOOK GRAPH RESULT: \(result)")
                completionHandler(success: true, result: result, error: nil)
            }
            
        })
    }
    
    func attemptLogin(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.authUser(email, password: password) { (error, authData) in
            
            if error != nil {
                print("Error for Firebase login: \(error)")
                completionHandler(success: false, error: "\(error.localizedDescription)")
            } else {
                completionHandler(success: true, error: nil)
            }
        }
        
    }
    
    func createUser(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
            print("createUser")
            if error != nil {
                if error.code == -9 {
                    completionHandler(success: false, error: "An account for this email already exists.")
                } else if  error.code == -15 {
                    completionHandler(success: false, error: "There is a problem with the Internet connection. Try again later.")
                } else {
                    completionHandler(success: false, error: "There was a problem creating the account.")
                }
            } else {
                let uid = result["uid"]
                print("Account succesfully created with uid: \(uid)")
                completionHandler(success: true, error: nil)
            }
            
        })
        
    }
    
    class func sharedInstance() -> FirebaseClient {
        struct Singletion {
            static var sharedInstance = FirebaseClient()
        }
        return Singletion.sharedInstance 
    }
    
}
