//
//  Firebase.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/11/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import Firebase

typealias CompletionHandler = (success: Bool, error: String?) -> Void

class FirebaseClient {
    
    let ref = Firebase(url: Constants.FIREBASE_URL)
    
    func attemptLogin(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.authUser(email, password: password) { (error, authData) in
            
            if error != nil {
                print("Error for Firebase login: \(error)")
                completionHandler(success: false, error: "There was a problem logging in.")
            } else {
                completionHandler(success: true, error: nil)
            }
        }
        
    }
    
    class func sharedInstance() -> FirebaseClient {
        struct Singletion {
            static var sharedInstance = FirebaseClient()
        }
        return Singletion.sharedInstance 
    }
    
}
