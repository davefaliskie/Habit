//
//  DetailViewController.swift
//  Habit
//
//  Created by David Faliskie on 3/1/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var totalCompleted: UILabel!
    @IBOutlet weak var habitNameTF: UITextField!
    var habit: HabitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    // loads the data and displays it on the page.
    func loadData() {
        guard let habitName = habit?.name else {fatalError("Cannot show detail without an item")}
        guard let habitDaysComplete = habit?.daysComplete else {fatalError("Cannot show detail without an item")}
        habitNameTF.text = habitName
        totalCompleted.text = String(habitDaysComplete)
    }

    
    // MARK: - Save / Update

    @IBAction func savePressed(_ sender: Any) {
        if let habit = habit {
            habit.name = habitNameTF.text
            DatabaseController.saveContext()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // Add one to days complete when pressed
    @IBAction func addCompleted(_ sender: Any) {
        if let habit = habit {
            habit.daysComplete = habit.daysComplete + 1
            DatabaseController.saveContext()
            loadData()
        }
    }
    
    

}
