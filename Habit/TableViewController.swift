//
//  TableViewController.swift
//  Habit
//
//  Created by David Faliskie on 2/28/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nav: UINavigationItem!
    
    var habits : [HabitData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
        
        nav.title = dailyTotals()
        scheduleNotification()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get data from core data
        fetchData()
        
        // reload table view
        tableView.reloadData()
        nav.title = dailyTotals()

        
    }

    
    // fetch the habit data and store it in the periviously created habits array
    func fetchData() {
        
        let fetchRequest:NSFetchRequest<HabitData> = HabitData.fetchRequest()
        
        do {
            habits = try DatabaseController.getContext().fetch(fetchRequest)
            
            } catch {
            print ("Error: \(error)")
        }
    }
    
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns number of rows
        return habits.count
    }

    
    // displays data to table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // defines the cell and calls the CustomCell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! CustomCell

        let habit = habits[indexPath.row]
        
        cell.habitNameLabel?.text = String(habit.name!)
        cell.daysCompleteLabel?.text = String(habit.daysComplete)
        cell.dateStarted?.text = formatDate(date: habit.dateCreated!)
        cell.daysFromStart?.text = "of \(String(daysFromStart(date: habit.dateCreated! as Date) + 1))"
        
        // shows if the habit was completed today in the cell
        isCompletedToday(habit: habit, cell: cell)
    
        
        cell.accessoryType = .disclosureIndicator
            
        
        // for the switch
        
        
        return cell
    }
    
    //MARK: count completes
    func dailyTotals() -> String{
        fetchData()
        let total = habits.count
        var complete = 0
        
        for habit in habits {
            if habit.completeToday == true {
                complete += 1
            }
        }
        return "\(complete) of \(total) Complete"
    }
    
    
    //String MM-dd-yy to Date Convert
    func stringToDate(string: String) -> Optional<Any> {
        let dateString = string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        let s = dateFormatter.date(from: dateString)
        return s
        
    }
    
    // function to get how many days from creation of habit
    public func daysFromStart(date: Date) -> Int {
        
        let startDateRaw: Date = date as Date
        let currentDateRaw: Date = Date()
        
        let startDate = stringToDate(string: formatDate(date: startDateRaw as NSDate))
        let currentDate = stringToDate(string: formatDate(date: currentDateRaw as NSDate))
        
        let currentCalendar = Calendar.current
        let start = currentCalendar.ordinality(of: .day, in: .era, for: startDate as! Date)
        let end = currentCalendar.ordinality(of: .day, in: .era, for: currentDate as! Date)
        let difference = (end! - start!)
        return difference
    }
    
    
    // function to format the date 
    func formatDate(date: NSDate) -> String {
        let todaysDate:NSDate = date
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        return DateInFormat
    }
    
    
    // MARK: custom swipe buttons
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let habit = self.habits[indexPath.row]
        
        // Complete Button
        let completeAction = UITableViewRowAction(style: .normal, title: "   Complete   ") {
            (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            // activity that will happen
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
            tableView.reloadData()
            self.nav.title = self.dailyTotals()

        }
        
        // NOT Complete Button
        let notCompleteAction = UITableViewRowAction(style: .normal, title: "Not Complete") {
            (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            // activity that will happen
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
            tableView.reloadData()
            self.nav.title = self.dailyTotals()
            
        }
        
        // DELETE Button
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            let context = DatabaseController.getContext()
            context.delete(habit)
            self.fetchData()
            DatabaseController.saveContext()
            tableView.reloadData()
            self.nav.title = self.dailyTotals()

        }
        
        let badges = "\(habit.currentStreak) streak"
        // DELETE Button
        let badgeAction = UITableViewRowAction(style: .normal, title: badges) {
            (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
        }
        
        

        
        // give buttons color
        completeAction.backgroundColor = UIColor(red:0.03, green:0.49, blue:0.55, alpha:1.0)
        notCompleteAction.backgroundColor = UIColor(red:0.03, green:0.49, blue:0.55, alpha:1.0)
        
        
        if habit.completeToday == false {
            return [completeAction, badgeAction, deleteAction]
        } else {
            return [notCompleteAction, badgeAction, deleteAction]
        }
        
    }
    
    
    
    
    
    // MARK: - Navigation and Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHabit" {
            nav.title = "Back"
            guard let destinationController = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let habit = habits[indexPath.row]
            destinationController.habit = habit
            
            
        }
    }
    
    // MARK: - completed today
    
    func isCompletedToday(habit: HabitData, cell: CustomCell) {
        if habit.lastComplete != nil {
            let difference = daysFromStart(date: habit.lastComplete! as Date)
            
            if (difference == 0) {
                habit.completeToday = true
                cell.completeImage.image = UIImage(named: "green")
            } else {
                habit.completeToday = false
                cell.completeImage.image = UIImage(named: "red")
            }
        }
    }
    
    
    
    // MARK: User Notifications 
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Check Yo Self"
        content.subtitle = "From Past Self"
        content.body = "Did you remember to complete all the habits you are working towards?"
        //content.badge = 1
        content.sound = UNNotificationSound.default()
        content.userInfo = ["id": 42]
        
        // let imageURL = Bundle.main.url(forResource: "blue", withExtension: "png")
        // let attachment = try! UNNotificationAttachment(identifier: "blue.png", url: imageURL!, options: nil)
        // content.attachments = [attachment]
        
        // for testing kick off notification 10 seconds after launch
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        // kick off notification everyday at 2:22 PM
        var date = DateComponents()
        date.hour = 14
        date.minute = 22
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "222.notification", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: nil)
        notificationCenter.delegate = self
        
        
    }

    
}


extension TableViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // this will actually display the notification while in the app
        completionHandler([.alert, .sound])
    }
}





