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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath)

        let habit = habits[indexPath.row]
        
        cell.textLabel?.text = habit.name!

        return cell
    }
    
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
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHabit" {
            guard let destinationController = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let habit = habits[indexPath.row]
            destinationController.habit = habit
        }
    }
    

}







