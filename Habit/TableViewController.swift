//
//  TableViewController.swift
//  Habit
//
//  Created by David Faliskie on 2/28/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var habits : [HabitData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 130

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get data from core data
        fetchData()
        
        // reload table view
        tableView.reloadData()
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
    
    
    //MARK: deleting
    
    // function to delete data from table using swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let context = DatabaseController.getContext()
            let item = habits[indexPath.row] as NSManagedObject
            context.delete(item)
            fetchData()
            DatabaseController.saveContext()
        }
        tableView.reloadData()
    }
    
    // function to deleat the table row
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return.delete
    }
    
    
    
    // MARK: - Navigation and Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHabit" {
            guard let destinationController = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let habit = habits[indexPath.row]
            destinationController.habit = habit
            
            
        }
    }
    
    // MARK: - completed today
    
    func isCompletedToday(habit: HabitData, cell: CustomCell) {
        let difference = daysFromStart(date: habit.lastComplete! as Date)
        
        if (difference == 0) {
            habit.completeToday = true
            cell.completeImage.image = UIImage(named: "check")
        } else {
            habit.completeToday = false
            cell.completeImage.image = UIImage(named: "miss")
        }
    }

    
}







