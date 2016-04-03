//
//  AddClassVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/3/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class AddClassVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AddClassVC.cancelButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func cancelButtonPressed() {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func saveButtonPressed(sender: AnyObject) {
        
    }

}
