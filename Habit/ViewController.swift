//
//  ViewController.swift
//  Habit
//
//  Created by David Faliskie on 2/24/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var habitNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // action for when the CANCEL button is pressed on the Create habit page
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    
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




















