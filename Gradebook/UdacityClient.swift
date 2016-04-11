//
//  UdacityClient.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/11/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class UdacityCient {
    
    var session = NSURLSession.sharedSession()
    
    func authenticateUser(username: String, password: String, completionHandlerForLogin: (success: Bool, error: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                completionHandlerForLogin(success: false, error: error)
            }
            
            guard error == nil else {
                sendError("\(error?.localizedDescription)")
                return
            }
            
            guard let data = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) else {
                sendError("No data was returned by the request")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                sendError("Unable to parse the JSON")
                return
            }
            
            guard let confirmation = parsedResult["account"] as? [String: AnyObject] else {
                sendError("Not registered")
                return
            }
            print("Confirmation: \(confirmation)")
            completionHandlerForLogin(success: true, error: nil)
            
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityCient {
        struct Singleton {
            static var sharedInstance = UdacityCient()
        }
        return Singleton.sharedInstance
    }
    
}


