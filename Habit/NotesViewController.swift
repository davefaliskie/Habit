//
//  NotesViewController.swift
//  Habit
//
//  Created by David Faliskie on 4/10/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextView!
    
    var habit: HabitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        if habit?.notes != nil {
            textField.text = habit?.notes!
        }
    
    }

    // saves any text that is modified
    func textViewDidEndEditing(_ textView: UITextView) {
        habit?.notes = textField.text
        DatabaseController.saveContext()
    }
    

    
}
