//
//  ViewController.swift
//  Habit
//
//  Created by David Faliskie on 2/24/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var habitNameTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting the Delegate for the TextField
        habitNameTF.delegate = self
        
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
        
        // saves data to the database
        DatabaseController.saveContext()
        
        // return home
        dismiss(animated: true, completion: nil)
    }
    
}




















