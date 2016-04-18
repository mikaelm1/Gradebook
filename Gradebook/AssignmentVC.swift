//
//  AssignmentVC.swift
//  Gradebook
//
//  Created by Mikael Mukhsikaroyan on 4/4/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import UIKit
import CoreData

class AssignmentVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - Outlets and Variables
    
    @IBOutlet weak var gradeScoreField: UITextField!
    @IBOutlet weak var gradeWeightField: UITextField!
    @IBOutlet weak var gradeReceivedField: UITextField!
    @IBOutlet weak var assignmentTitleField: UITextField!
    @IBOutlet weak var assignmentDescriptionField: UITextView!
    
    var course: Course!
    var assignment: Assignment?
    var pickerView: UIPickerView!
    var grades = Grade.GradeLetter.allGrades
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickers()
        setUpFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if assignment != nil {
            fillInFieldsForAssignment(assignment!)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Helper methods
    
    func fillInFieldsForAssignment(assignment: Assignment) {
        gradeReceivedField.text = assignment.gradeLetter
        gradeWeightField.text = "\(Int(assignment.gradeWeight))"
        gradeScoreField.text = "\(Int(assignment.gradeScore))"
        assignmentTitleField.text = assignment.assignmentTitle
        assignmentDescriptionField.text = assignment.assignmentDescription
    }
    
    func setUpFields() {
        
        gradeScoreField.addTarget(self, action: #selector(AssignmentVC.textFieldEdited(_:)), forControlEvents: .EditingChanged)
        gradeWeightField.addTarget(self, action: #selector(AssignmentVC.textFieldEdited(_:)), forControlEvents: .EditingChanged)
        
        gradeReceivedField.delegate = self
        assignmentTitleField.delegate = self
    }
    
    func setUpPickers() {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.grayColor()
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(AssignmentVC.pickerCancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(AssignmentVC.pickerDoneButtonPressed))
        
        toolBar.setItems([doneButton, spaceButton, cancelButton], animated: true)
        
        gradeReceivedField.inputView = pickerView
        gradeReceivedField.inputAccessoryView = toolBar

    }
    
    func pickerDoneButtonPressed() {
        let selectedItem = pickerView.selectedRowInComponent(0)
        if selectedItem == 0 {
            gradeReceivedField.text = grades[selectedItem].rawValue
        }
        gradeReceivedField.resignFirstResponder()
    }
    
    func pickerCancelPressed() {
        gradeReceivedField.resignFirstResponder()
        if assignment != nil {
            gradeReceivedField.text = assignment?.gradeLetter
        } else {
            gradeReceivedField.text = ""
        }
    }
    
    func sendAlert(message: String, fieldNeeded: UITextField) {
        let alert = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action) in
            
            fieldNeeded.becomeFirstResponder()
        }
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Picker View Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return grades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return grades[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gradeReceivedField.text = grades[row].rawValue
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldEdited(sender: UITextField) {
        guard let textToReplace = sender.text else {
            return
        }
        if textToReplace.characters.count > 2 {
            let ending = textToReplace.startIndex.advancedBy(2)
            sender.text = textToReplace.substringToIndex(ending)
        }
        if Int(textToReplace) == nil {
            return
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 0 {
            let grades = Grade.GradeLetter.allGradesRaw
            if grades.contains(string) {
                return true
            }
        }
        return false 

    }

    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        var assignmentDesc = "No description entered."
        
        guard let grade = gradeReceivedField.text where grade != "" else {
            sendAlert("Please enter a grade.", fieldNeeded: gradeReceivedField)
            return
        }
        
        guard let weight = Double(gradeWeightField.text!) else {
            sendAlert("Please enter the percent this assignment has in the course.", fieldNeeded: gradeWeightField)
            return
        }
        
        guard let title = assignmentTitleField.text where title != "" else {
            sendAlert("Please enter a title for the assignment", fieldNeeded: assignmentTitleField)
            return
        }
        
        guard let gradeScore = Double(gradeScoreField.text!) else {
            sendAlert("Please enter a score between 0 and 100", fieldNeeded: gradeScoreField)
            return 
        }
        
        if let desc = assignmentDescriptionField.text {
            assignmentDesc = desc
        }
        
        let gradeValue = getGrade(grade)
        
        if assignment == nil {
            let assignmentToSave = Assignment(assignmentTitle: title, gradeWeight: weight, gradeValue: gradeValue, gradeLetter: grade, context: sharedContext, assignmentDescription: assignmentDesc, gradeScore: gradeScore)
            assignmentToSave.course = course
        } else {
            assignment?.setValue(title, forKey: "assignmentTitle")
            assignment?.setValue(weight, forKey: "gradeWeight")
            assignment?.setValue(gradeValue, forKey: "gradeValue")
            assignment?.setValue(grade, forKey: "gradeLetter")
            assignment?.setValue(assignmentDesc, forKey: "assignmentDescription")
        }

        CoreDataStackManager.sharedInstance().saveContext()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func getGrade(letter: String) -> Double {
        let selectedGradeIndex = pickerView.selectedRowInComponent(0)
        let grade = grades[selectedGradeIndex].getGradeValue()
        return grade
    }

}
