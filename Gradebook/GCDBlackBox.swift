//
//  GCDBlackBox.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/11/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import Foundation

func performUpdatesOnMain(updates: () -> Void ) {
    dispatch_async(dispatch_get_main_queue()) {
        updates() 
    }
}
