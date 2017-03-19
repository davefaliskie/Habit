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
    
    var badges: Array<String> = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Load: \(badges)")
        badgeTableView.dataSource = self
        badgeTableView.delegate = self
        
        badgeTableView.rowHeight = 150
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.badges.count
    }
    
    // displays data to table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // defines the cell and calls the CustomCell class
        let cell = self.badgeTableView.dequeueReusableCell(withIdentifier: "BadgesTableViewCell", for: indexPath) as! BadgesTableViewCell
        
        let badge = badges[indexPath.row]
        cell.badgeImage.image = UIImage(named: badge)
        
        return cell
        
    }
    
    
    


}


