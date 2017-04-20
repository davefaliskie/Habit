//
//  DetailViewController.swift
//  Habit
//
//  Created by David Faliskie on 3/1/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var totalCompleted: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var notCompleteBtn: UIButton!
    @IBOutlet weak var badgeView: UICollectionView!
    @IBOutlet weak var historyView: UICollectionView!
    @IBOutlet weak var currentStreak: UILabel!
    @IBOutlet weak var highestStreak: UILabel!
    @IBOutlet weak var badgeCountLable: UILabel!
    @IBOutlet weak var nav: UINavigationItem!
    
    // testing values data
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var lastCompleteDate: UILabel!
    
    let TVC = TableViewController()
    
    var habit: HabitData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.title = habit!.name!
        // set Collect view delegates
        badgeView.delegate = self
        historyView.delegate = self
        
        badgeView.dataSource = self
        historyView.dataSource = self
        
        self.view.addSubview(badgeView)
        self.view.addSubview(historyView)
        
        loadData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nav.title = habit!.name!
    }
    
    // loads the data and displays it on the page.
    func loadData() {
        
        checkCurrentStreak()
        
        guard let habitName = habit?.name else {fatalError("Cannot show detail without an item")}
        guard let habitDaysComplete = habit?.daysComplete else {fatalError("Cannot show detail without an item")}
        guard let currentStreakCount = habit?.currentStreak else {fatalError("Error with current streak")}
        guard let highestStreakCount = habit?.highestStreak else{fatalError("Error with highest Streak")}
        
        habitNameLabel.text = String(habitName)
        totalCompleted.text = String(habitDaysComplete)
        currentStreak.text = String(currentStreakCount)
        highestStreak.text = String(highestStreakCount)
        
        
        // Make labels circle
        makeCircle(label: totalCompleted)
        makeCircle(label: currentStreak)
        makeCircle(label: highestStreak)
        
        // sets the 'Complete' btns based on daily activity
        if habit?.lastComplete == nil {
            completeBtn.isEnabled = true
            completeBtn.isHidden = false
            notCompleteBtn.isEnabled = false
            notCompleteBtn.isHidden = true
        } else {
            completeBtnEnabled(lastComplete: (habit?.lastComplete!)!)
        }
        
        badgeView.reloadData()
        historyView.reloadData()
        showDates()
        setBadgeFlags()
        
    }
    
    // MARK: make labels circle
    func makeCircle(label: UILabel) {
        label.layer.cornerRadius = label.frame.width/2
        label.layer.borderWidth = 0.5
        label.layer.borderWidth = 5.0
        label.layer.borderColor = UIColor(red:0.03, green:0.49, blue:0.55, alpha:1.0).cgColor
    }
    
    // MARK: - Save / Update
    // removed... No need to allow user to edit habit title.

//    @IBAction func savePressed(_ sender: Any) {
//        if let habit = habit {
//            habit.name = habitNameTF.text
//            DatabaseController.saveContext()
//            _ = navigationController?.popViewController(animated: true)
//        }
//    }
    
    
    // MARK: Completed buttons and logic
    // Add one to days complete when pressed
    @IBAction func addCompleted(_ sender: Any) {
        if let habit = habit {
            habit.daysComplete = habit.daysComplete + 1
            habit.lastCompleteSave = habit.lastComplete
            habit.lastComplete = NSDate()
            habit.currentStreak = habit.currentStreak + 1
            habit.completeToday = true
            
            // will append a check image to the collection view
            if habit.history == nil {
                habit.history = ["green"]
            } else {
                habit.history?.insert("green", at: 0)
            }
            
            // saves all changes and reloads the view
            DatabaseController.saveContext()
            loadData()
        }
    }
    
    // Subtract one to days complete when pressed
    @IBAction func removeComplete(_ sender: Any) {
        if let habit = habit {
            habit.daysComplete = habit.daysComplete - 1
            habit.lastComplete = habit.lastCompleteSave
            habit.currentStreak = habit.currentStreak - 1
            habit.completeToday = false
            
            // check if highest streak needs to be decremented
            if habit.streakEqual == true {
                habit.highestStreak = habit.highestStreak - 1
            }
            
            // pop the first check from the array
            habit.history?.removeFirst()
            
            // saves all changes and reloads the view
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
            
            completeBtn.isHidden = true
            notCompleteBtn.isHidden = false
        } else {
            habit?.completeToday = false
            completeBtn.isEnabled = true
            notCompleteBtn.isEnabled = false
            
            completeBtn.isHidden = false
            notCompleteBtn.isHidden = true
        }
        
    }
    
    
    
//    // MARK: Disable the save button until some text is entered
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        // Find out what the text field will be after adding the current edit
//        let text = (habitNameTF.text! as NSString).replacingCharacters(in: range, with: string)
//        
//        //Checking if the input field is empty
//        if text.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty{
//            // Disable Save Button
//            saveBtn.isEnabled = false
//        } else {
//            // Enable Save Button
//            saveBtn.isEnabled = true
//        }
//        return true
//    }
    
    
    
    //MARK: Streak
    
    // function to set current streak back to zero if habit is missed for one whole day &&& set the higest streak.
    func checkCurrentStreak() {
        if let habit = habit {
            if ((habit.lastComplete) != nil) {
                // set the higest streak to the higest current streak.
                if habit.currentStreak > habit.highestStreak {
                    habit.highestStreak = habit.currentStreak
                    habit.streakEqual = true
                    DatabaseController.saveContext()
                }
                
                // reset current streak to zero if a day is missed
                let difference = TVC.daysFromStart(date: habit.lastComplete! as Date)
                if difference >= 2 {
                    habit.currentStreak = 0
                    habit.streakEqual = false
                    DatabaseController.saveContext()
                }
            }
            // Place "miss" image in the history view
            let historyMax = TVC.daysFromStart(date: habit.dateCreated! as Date)
            while (habit.history != nil) && (historyMax > (habit.history?.count)!) {
                habit.history?.insert("red", at: 0)
            }
        }
    }
    
    

    
    
    
    
    // MARK: Badges/ History Collection Views
    
    func getHistory() -> Array<String>{
        if let habit = habit {
            let history = habit.history
            if history != nil {
                return history as! Array<String>
            }
        }
        return ["first"]
    }
    
    
    func getBadges() -> Array<String>{
        let habit = self.habit
        
        var badges = habit?.badges as? Array <String>
        
        if badges == nil {
            badges = ["one"]
            //badges = ["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen","X3","X5","X7","X10","X15","X20","X25","X30"]
        }
        
        // Build Flower of Life
        if (habit?.daysComplete)! >= 2 {
            badges!.append("two")
        }
        if (habit?.daysComplete)! >= 3 {
            badges!.append("three")
        }
        if (habit?.daysComplete)! >= 4 {
            badges!.append("four")
        }
        if (habit?.daysComplete)! >= 5 {
            badges!.append("five")
        }
        if (habit?.daysComplete)! >= 6 {
            badges!.append("six")
        }
        if (habit?.daysComplete)! >= 7 {
            badges!.append("seven")
        }
        if (habit?.daysComplete)! >= 8 {
            badges!.append("eight")
        }
        if (habit?.daysComplete)! >= 9 {
            badges!.append("nine")
        }
        if (habit?.daysComplete)! >= 10 {
            badges!.append("ten")
        }
        if (habit?.daysComplete)! >= 11 {
            badges!.append("eleven")
        }
        if (habit?.daysComplete)! >= 12 {
            badges!.append("twelve")
        }
        if (habit?.daysComplete)! >= 13 {
            badges!.append("thirteen")
        }
        if (habit?.daysComplete)! >= 14 {
            badges!.append("fourteen")
        }
        if (habit?.daysComplete)! >= 15 {
            badges!.append("fifteen")
        }
        if (habit?.daysComplete)! >= 16 {
            badges!.append("sixteen")
        }
        if (habit?.daysComplete)! >= 17 {
            badges!.append("seventeen")
        }
        if (habit?.daysComplete)! >= 18 {
            badges!.append("eighteen")
        }
        if (habit?.daysComplete)! >= 19 {
            badges!.append("nineteen")
        }
        
        //Streak Badges 
        if (habit?.highestStreak)! >= 3{
            badges!.append("X3")
        }
        if (habit?.highestStreak)! >= 5{
            badges!.append("X5")
        }
        if (habit?.highestStreak)! >= 7{
            badges!.append("X7")
        }
        if (habit?.highestStreak)! >= 10{
            badges!.append("X10")
        }
        if (habit?.highestStreak)! >= 15{
            badges!.append("X15")
        }
        if (habit?.highestStreak)! >= 20{
            badges!.append("X20")
        }
        if (habit?.highestStreak)! >= 25{
            badges!.append("X25")
        }
        if (habit?.highestStreak)! >= 30{
            badges!.append("X30")
        }
        
        // missed more then 3 days 
        if habit?.was_zzz == true {
            badges!.insert("ZZZ", at: 0)
        }

        DatabaseController.saveContext()
        
        badgeCountLable.text = String(describing: badges!.count)
        
        return badges!.reversed()
    }
        
    
    func setBadgeFlags() {
        // set ZZZ Badge
        if habit?.lastComplete != nil {
            let daysDifference = TVC.daysFromStart(date: (habit?.lastComplete)! as Date)
            if daysDifference > 3 {
                habit?.was_zzz = true
            }
        }
        
        //

    }

    
    
    
    // mandatory functions for collection view 
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // for badge collection view count
        if collectionView == self.badgeView {
            return getBadges().count
        }
        // for history collection view count
        return getHistory().count
    }
    
    
    // Displays all the images from the images array to the View
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // for badge collection view
        if collectionView == self.badgeView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath) as! BadgesCell
            
            // style to make round and add border
            cell.layer.cornerRadius = 50
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
            
            
            cell.badgeImage.image = UIImage(named: getBadges()[indexPath.row])
            cell.badgeImage.contentMode = .scaleAspectFit
            
            return cell
        }
            
        // for History collection view
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            
            cellB.historyImage.image = UIImage(named: getHistory()[indexPath.row])
            cellB.historyImage.contentMode = .scaleAspectFit
            
            return cellB

        }
    }
    
    

    
    
    
    // MARK: Display dates data
    func showDates() {
//        if habit?.lastComplete != nil {
//            let daysDifference = TVC.daysFromStart(date: habit?.lastComplete! as! Date)
//        }
        if habit?.lastComplete != nil {
            let last = TVC.formatDate(date: (habit?.lastComplete)!)
            lastCompleteDate.text = String(describing: last)
        }
        
        let start = TVC.formatDate(date: (habit?.dateCreated)!)
        startDate.text = String(describing: start)
        
    }
    
    
    // Segue to Badges View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBadges" {
            nav.title = "Back"
            guard let destinationController = segue.destination as? BadgeTableViewController else {return}
            destinationController.badges = getBadges()
            let habit = self.habit
            destinationController.habit = habit!
            destinationController.nav.title = habit!.name!
        }
        if segue.identifier == "showNotes" {
            nav.title = "Back"
            guard let destinationController = segue.destination as? NotesViewController else {return}
            let habit = self.habit
            destinationController.habit = habit
        }
        if segue.identifier == "showHistory" {
            nav.title = "Back"
            guard let destinationController = segue.destination as? HistoryViewController else {return}
            let habit = self.habit
            destinationController.habit = habit
        }
    }
}
