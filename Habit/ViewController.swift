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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addData()
        fetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func addData() {
        // makes CoreData manage the habitData variable
        let habitData = HabitData(context: DatabaseController.getContext())
        
        habitData.name = "Run"
        habitData.daysComplete = 3
        
        // saves data to the database
        DatabaseController.saveContext()
    }
    
    func fetchData() {
        
        let fetchRequest:NSFetchRequest<HabitData> = HabitData.fetchRequest()
        
        do {
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [HabitData] {
                print("\(result.name!) has been completed \(result.daysComplete) times")
            }
        } catch {
            print ("Error: \(error)")
        }
    }
    
}

