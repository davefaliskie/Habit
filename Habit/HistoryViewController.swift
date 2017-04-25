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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        rate.text = "\(setRate()) %"
        
        makeCircle(label: rate)
        
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

    }



    




