//
//  BadgeTableViewController.swift
//  Habit
//
//  Created by David Faliskie on 3/19/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class BadgeTableViewController: UITableViewController  {

    
    @IBOutlet weak var badgeTableView: UITableView!
    @IBOutlet var nav: UINavigationItem!
    
    var badges: Array<String> = []

    var habit: HabitData?
    
    
    var daily: Array<String> = []
    var streak: Array<String> = []
    var other: Array<String> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badgeTableView.dataSource = self
        badgeTableView.delegate = self
        badgeTableView.rowHeight = 150
        
        sortBadges(badges: badges.reversed())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1) {
            return "Completion Badges"
        }
        if(section == 2) {
            return "Streak Badges"
        }else {
            return "Other Badges"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.badges.count
        if(section == 1) {
            return daily.count
        }
        if(section == 2) {
            return streak.count
        }
        else {
            return other.count
        }
    }
    
    // displays data to table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // defines the cell and calls the CustomCell class
        let cell = self.badgeTableView.dequeueReusableCell(withIdentifier: "BadgesTableViewCell", for: indexPath) as! BadgesTableViewCell
        
        // style to make round and add border
        cell.badgeImage.layer.cornerRadius = 50
        cell.badgeImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.badgeImage.layer.borderWidth = 0.5
        cell.badgeImage.clipsToBounds = true
        
        if(indexPath.section == 1) {
            let badge = daily[indexPath.row]
            cell.badgeImage.image = UIImage(named: badge)
            cell.badgeTitle.text = badge
        }
        else if(indexPath.section == 2) {
            let badge = streak[indexPath.row]
            cell.badgeImage.image = UIImage(named: badge)
            cell.badgeTitle.text = badge
        }
        else {
            let badge = other[indexPath.row]
            cell.badgeImage.image = UIImage(named: badge)
            cell.badgeTitle.text = badge
        }
        
        cell.badgeImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func sortBadges(badges: Array<String>) {
        for (_, b) in badges.enumerated() {
            if (b == "one" || b == "two" || b == "three" || b == "four" || b == "five" || b == "six" || b == "seven" || b == "eight" || b == "nine" || b == "ten" || b == "eleven" || b == "twelve" || b == "thirteen" || b == "fourteen" || b == "fifteen" || b == "sixteen" || b == "seventeen" || b == "eighteen" || b == "nineteen") {
                daily.append(b)
                continue
            }
            if (b == "X3" || b == "X5" || b == "X7" || b == "X10" || b == "X15" || b == "X20" || b == "X25" || b == "X30"){
                streak.append(b)
                continue
            }
            else {
                other.append(b)
            }
        }
    }
    
    
    


}


