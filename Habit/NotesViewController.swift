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
    @IBOutlet weak var nav: UINavigationItem!
    
    var habit: HabitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.title = habit!.name!
        textField.delegate = self
        if habit?.notes != nil {
            textField.text = habit?.notes!
        }
        NotificationCenter.default.addObserver(self, selector: #selector(NotesViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotesViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Swip down to hide keyboard
        let tap: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NotesViewController.dismissKeyboard))
        tap.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if habit?.notes != nil {
            textField.text = habit?.notes!
        }
    }

    // saves any text that is modified
    func textViewDidEndEditing(_ textView: UITextView) {
        habit?.notes = textField.text
        DatabaseController.saveContext()
    }
    
    
    //MARK: Show/ Hide keyboard
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                self.textField.frame.size.height -= keyboardSize.height
                self.textField.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                self.textField.frame.size.height += keyboardSize.height
                self.textField.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
}
