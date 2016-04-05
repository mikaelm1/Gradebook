//
//  AssignmentVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/4/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit

class AssignmentVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var gradeWeightField: UITextField!
    @IBOutlet weak var gradeReceivedField: UITextField!
    @IBOutlet weak var assignmentTitleField: UITextField!
    @IBOutlet weak var assignmentDescriptionField: UITextView!
    
    var pickerView: UIPickerView!
    var grades = ["A", "B", "C", "D", "F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickers()
    }
    
    func setUpPickers() {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.grayColor()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AssignmentVC.pickerDoneButtonPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(AssignmentVC.pickerDoneButtonPressed))
        
        toolBar.setItems([doneButton, spaceButton, cancelButton], animated: true)
        
        gradeReceivedField.inputView = pickerView
        gradeReceivedField.inputAccessoryView = toolBar

    }
    
    func pickerDoneButtonPressed() {
        gradeReceivedField.resignFirstResponder()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return grades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return grades[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gradeReceivedField.text = grades[row]
    }

    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        print("Save button pressed")
    }

}
