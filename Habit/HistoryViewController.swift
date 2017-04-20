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
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    
    // mandatory functions for collection view
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habit.history!.count
    }
    
    
    // Displays all the images from the images array to the View
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HCell", for: indexPath) as! HCell
        
            let history = habit!.history as! Array<String>
            cell.HImage.image = UIImage(named: history[indexPath.row])
            cell.HImage.contentMode = .scaleAspectFit
            
            return cell
        }

    }

    




