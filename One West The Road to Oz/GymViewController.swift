//
//  GymViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse

class GymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let currentUser = User.currentUser()
    var sec1Array : [GymWorkouts]?
    var sec2Array : [GymWorkouts]?
    var sec3Array : [GymWorkouts]?
    var sectionArray : [NSArray] = []
    
    var pickerArray : [NSDate] = []
    var thisWeek : GymWorkouts?
    var workoutsArray = [GymWorkouts]()
    var selectedWeek : NSDate?
    
    @IBOutlet weak var weekStartingButton: UIButton!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPointsLabel()
        
        if selectedWeek == nil {
            self.queryForLastWorkoutDate()
            self.sec1Array = []
            self.sec2Array = []
            self.sec3Array = []
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func weekStartingButtonPressed(sender: UIButton) {
    }
    
    // MARK: Parse Helper Methods
    
    func fillPickerArray() {
        var query = GymWorkouts.query()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            for object in objects {
                var workout = object as GymWorkouts
                if self.pickerArray.last != workout.weekStarting {
                    self.pickerArray.append(workout.weekStarting)
                }
                
            }
            
        }
    }
    
    func queryForLastWorkoutDate() {
        
        var query = GymWorkouts.query()
        query.whereKey("weekStarting", lessThan: Constants.todaysDate)
        query.orderByDescending("weekStarting")
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject!, error: NSError!) -> Void in
            if (error == nil) {
                self.thisWeek = object as? GymWorkouts
                self.queryForWorkouts(self.thisWeek!.weekStarting)
            }
            else {
                println(error)
            }
        }
        
    }
    
    func queryForWorkouts(weekStarting : NSDate) {
        self.workoutsArray.removeAll()
        var query = GymWorkouts.query()
        query.whereKey("weekStarting", equalTo: weekStarting)
        query.orderByAscending("day")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                for object in objects {
                    self.workoutsArray.append(object as GymWorkouts)
                }
                for workout in self.workoutsArray {
                    if workout.day == "Day 1" {
                        self.sec1Array!.append(workout)
                    }
                    else if workout.day == "Day 2" {
                        self.sec2Array!.append(workout)
                        println(self.sec2Array)
                    }
                    else if workout.day == "Day 3" {
                        self.sec3Array!.append(workout)
                    }
                    
                }

                self.sectionArray.append(self.sec1Array!)
                self.sectionArray.append(self.sec2Array!)
                self.sectionArray.append(self.sec3Array!)
    
                var thisWeek = Global.setWeekFromDate(weekStarting)
                self.configureWeekStartingButton(thisWeek)
                self.tableView.reloadData()
            }
            else {
                println(error)
            }
            
        }
//        if (self.refreshControl != nil) {
//            self.refreshControl.endRefreshing()
//        }
        
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : GymWorkoutsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GymWorkoutsCell", forIndexPath: indexPath) as GymWorkoutsTableViewCell
        println(sectionArray)
        var array = sectionArray[indexPath.section]
        var workout = array[indexPath.row] as GymWorkouts
        
        cell.workoutLabel.text = workout.workout
        cell.repsLabel.text = workout.reps
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Day 1"
        case 1:
            return "Day 2"
            
        case 2:
            return "Day 3"
            
        default:
            return "Default Section"
            
        }
        
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, DidSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row Selected")
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // MARK: Helper Methods
    func setUpPointsLabel() {
        self.pointsLabel.text = "Points: " + String(self.currentUser.gymPoints)
    }
    
    func configureWeekStartingButton(currentWeek : String) {
        self.weekStartingButton.setTitle("Week Starting: " + currentWeek, forState: .Normal)
    }

}
