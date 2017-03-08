//
//  DetailViewController.swift
//  Habit
//
//  Created by David Faliskie on 3/1/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var totalCompleted: UILabel!
    @IBOutlet weak var habitNameTF: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var notCompleteBtn: UIButton!
    
    let TVC = TableViewController()
    
    var habit: HabitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the Delegate for the TextField
        habitNameTF.delegate = self
        
        loadData()
    }
    
    // loads the data and displays it on the page.
    func loadData() {
        guard let habitName = habit?.name else {fatalError("Cannot show detail without an item")}
        guard let habitDaysComplete = habit?.daysComplete else {fatalError("Cannot show detail without an item")}
        habitNameTF.text = habitName
        totalCompleted.text = String(habitDaysComplete)
        
        // sets the 'Complete' btns based on daily activity
        if habit?.lastComplete == nil {
            notCompleteBtn.isEnabled = false
        } else {
            completeBtnEnabled(lastComplete: (habit?.lastComplete!)!)
        }
    }

    
    // MARK: - Save / Update

    @IBAction func savePressed(_ sender: Any) {
        if let habit = habit {
            habit.name = habitNameTF.text
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Completed buttons and logic
    // Add one to days complete when pressed
    @IBAction func addCompleted(_ sender: Any) {
        if let habit = habit {
            habit.daysComplete = habit.daysComplete + 1
            habit.lastComplete = NSDate()
            DatabaseController.saveContext()
            loadData()
        }
    }
    
    // Subtract one to days complete when pressed
    @IBAction func removeComplete(_ sender: Any) {
        if let habit = habit {
            habit.daysComplete = habit.daysComplete - 1
            habit.lastComplete = NSDate.distantPast as NSDate?
            DatabaseController.saveContext()
            loadData()
        }
    }
    
    
    // function to disable the complete button if already completed today.
    func completeBtnEnabled (lastComplete: NSDate) {
        
        let difference = TVC.daysFromStart(date: lastComplete as Date)
        
        if (difference == 0) {
            completeBtn.isEnabled = false
            notCompleteBtn.isEnabled = true
        } else {
            completeBtn.isEnabled = true
            notCompleteBtn.isEnabled = false
        }
        
    }
    
    
    
    // MARK: Disable the save button until some text is entered
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
    
    

}
