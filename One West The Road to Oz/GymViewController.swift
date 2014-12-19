//
//  GymViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit

class GymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

        var sec1Array = []
        var sec2Array = []
        var sec3Array = []
        var sectionArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sec1Array = ["Item 1", "Item 2", "Item 3", "Item 4"]
        sec2Array = ["Item 1", "Item 2", "Item 3", "Item 4"]
        sec3Array = ["Item 1", "Item 2", "Item 3", "Item 4"]
        sectionArray = [sec1Array, sec2Array, sec3Array]

        // Do any additional setup after loading the view.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : GymWorkoutsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GymWorkoutsCell", forIndexPath: indexPath) as GymWorkoutsTableViewCell
        
        var array = sectionArray[indexPath.section]
        
        cell.workoutLabel.text = array[indexPath.row] as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Section 1"
        case 1:
            return "Section 2"
            
        case 2:
            return "Section 3"
            
        default:
            return "Default Section"
            
        }
        
    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, DidSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row Selected")
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    
    

}
