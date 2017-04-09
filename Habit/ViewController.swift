//
//  ViewController.swift
//  Habit
//
//  Created by David Faliskie on 2/24/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var habitNameTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting the Delegate for the TextField
        habitNameTF.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        //Default checking and disabling of the Button
        if (habitNameTF.text?.isEmpty)!{
            saveBtn.isEnabled = false
        }
        
        
        
    }
    
    
    // action for when the CANCEL button is pressed on the Create habit page
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Disable the save button until some text is entered
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Find out what the text field will be after adding the current edit
        let text = (habitNameTF.text! as NSString).replacingCharacters(in: range, with: string)
        
        //Checking if the input field is empty
        if text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
            // Disable Save Button
            saveBtn.isEnabled = false
        } else {
            // Enable Save Button
            saveBtn.isEnabled = true
        }
        return true
    }
    
    
    // action for when the SAVE button is pressed on the Create habit page
    @IBAction func saveButton(_ sender: Any) {
        // makes CoreData manage the habitData variable
        let habitData = HabitData(context: DatabaseController.getContext())
        
        // store the input as the name
        habitData.name = habitNameTF.text
        
        // store the date created
        habitData.dateCreated = NSDate()
        
        // saves data to the database
        DatabaseController.saveContext()
        
        // return home
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Picker View
    
    var habitChoices = ["Select a habit",
                        "Run",
                        "Read",
                        "Write",
                        "Strech",
                        "Wake Up Early",
                        "Exercise",
                        "Pray",
                        "Meditate",
                        "Drink Water",
                        "Journal",
                        "Laugh",
                        "Eat Healthy",
                        "Practice a New Language",
                        "Practice an Instrument",
                        "Floss",
                        "Take a Vitamin"
                        ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return habitChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return habitChoices[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        habitNameTF.text = habitChoices[row]
        if habitNameTF.text == habitChoices[0] {
            habitNameTF.text = ""
            saveBtn.isEnabled = false
        }else {
            saveBtn.isEnabled = true
        }
    }
    
}




















