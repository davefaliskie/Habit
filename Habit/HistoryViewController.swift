//
//  HistoryViewController.swift
//  Habit
//
//  Created by David Faliskie on 4/19/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var habit: HabitData!
    var totalDays: Int32?
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var bestDay: UILabel!
    @IBOutlet weak var worstDay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        rate.text = "\(setRate()) %"
        
        makeCircle(label: rate)

        sortDays(rawHistory: habit.history!)
        
    }
    
    // MARK: make labels circle
    public func makeCircle(label: UILabel) {
        label.layer.cornerRadius = label.frame.width/2
        label.layer.borderWidth = 0.5
        label.layer.borderWidth = 5.0
        label.layer.borderColor = UIColor(red:0.03, green:0.49, blue:0.55, alpha:1.0).cgColor
    }
    
    // set days of week as buffer
    func addBuffer(history: Array<String>) -> Array<String> {
        // check what day it is
        let today = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar!.components([.weekday], from: today as Date)
        
        // Sunday
        var buffer: Array<String> = ["Sun","Sat","Fri","Thr","Wed","Tu","Mon"]
        
        // set buffer based on current day
        if components.weekday == 2 {
            //Monday
            buffer = ["Mon","Sun","Sat","Fri","Thr","Wed","Tu"]
        }
        if components.weekday == 3 {
            //Tuesday
            buffer = ["Tu","Mon","Sun","Sat","Fri","Thr","Wed"]
        }
        if components.weekday == 4 {
            //Wednesday
            buffer = ["Wed","Tu","Mon","Sun","Sat","Fri","Thr"]
        }
        if components.weekday == 5 {
            //Thursday
            buffer = ["Thr","Wed","Tu","Mon","Sun","Sat","Fri"]
        }
        if components.weekday == 6 {
            //Friday
            buffer = ["Fri","Thr","Wed","Tu","Mon","Sun","Sat"]
        }
        if components.weekday == 7 {
            //Saturday
            buffer = ["Sat","Fri","Thr","Wed","Tu","Mon","Sun"]
            
        }
        
        var combined: Array<String> = []
        
        if habit.completeToday == false {
            let complete = ["?"]
            combined = buffer + complete + history
        }else {
            combined = buffer + history
        }
    
        
        return combined
    }
    
    
    // set percent complete
    func setRate() -> Int32 {
        let daysComplete = Float(habit.daysComplete)
        let percent = Int32((daysComplete / Float(totalDays!)) * 100.0)
        return percent
    }
    
    
    
    // mandatory functions for collection view
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addBuffer(history: habit!.history as! Array<String>).count
    }
    
    
    // Displays all the images from the images array to the View
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCell", for: indexPath) as! HCell
        
        let history = addBuffer(history: habit!.history as! Array<String>)
        cell.HImage.image = UIImage(named: history[indexPath.row])
        cell.HImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    // 
    func sortDays(rawHistory: Array<Any>) {
        // reverse so first element is first day.
        let history = Array(rawHistory.reversed())
        
        // get the day of the week the habit was first 
        let startDate = habit.dateCreated
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let firstDay = calendar!.components([.weekday], from: startDate! as Date)
        
        var currentDay = firstDay.weekday!
        
        var sun = 0
        var mon = 0
        var tu = 0
        var wed = 0
        var thr = 0
        var fri = 0
        var sat = 0
        
        var days: Array<Int> = []
        
        for i in 0..<history.count {
            if String(describing: history[i]) == "green" { days.append(currentDay) }
            if currentDay == 7 { currentDay = 1 } else { currentDay += 1 }
        }
        for day in days {
            if day == 1 {sun+=1}
            if day == 2 {mon+=1}
            if day == 3 {tu+=1}
            if day == 4 {wed+=1}
            if day == 5 {thr+=1}
            if day == 6 {fri+=1}
            if day == 7 {sat+=1}
        }
        
        let totals = [sun,mon,tu,wed,thr,fri,sat]
        let maxDay = 1+totals.index(of: totals.max()!)!
        let minDay = 1+totals.index(of: totals.min()!)!
        
        if maxDay == 1 {bestDay.text = "Sunday"}
        if maxDay == 2 {bestDay.text = "Monday"}
        if maxDay == 3 {bestDay.text = "Tuesday"}
        if maxDay == 4 {bestDay.text = "Wednesday"}
        if maxDay == 5 {bestDay.text = "Thursday"}
        if maxDay == 6 {bestDay.text = "Friday"}
        if maxDay == 7 {bestDay.text = "Saturday"}
        
        if minDay == 1 {worstDay.text = "Sunday"}
        if minDay == 2 {worstDay.text = "Monday"}
        if minDay == 3 {worstDay.text = "Tuesday"}
        if minDay == 4 {worstDay.text = "Wednesday"}
        if minDay == 5 {worstDay.text = "Thursday"}
        if minDay == 6 {worstDay.text = "Friday"}
        if minDay == 7 {worstDay.text = "Saturday"}
    }

}



    




