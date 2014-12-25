//
//  GymViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse

class GymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    let currentUser = User.currentUser()
    var day1Array : [GymWorkouts]?
    var day2Array : [GymWorkouts]?
    var day3Array : [GymWorkouts]?
    var weekArray : [NSArray] = []
    
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
            self.day1Array = []
            self.day2Array = []
            self.day3Array = []
        }

        var tapGesture = UITapGestureRecognizer(target: self, action: "workoutAlert:")
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(tapGesture)    }
    
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
                        self.day1Array!.append(workout)
                    }
                    else if workout.day == "Day 2" {
                        self.day2Array!.append(workout)
                    }
                    else if workout.day == "Day 3" {
                        self.day3Array!.append(workout)
                    }
                    
                }

                self.weekArray.append(self.day1Array!)
                self.weekArray.append(self.day2Array!)
                self.weekArray.append(self.day3Array!)
    
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
    
    func checkForCompletion(workout : GymWorkouts, indexPath : NSIndexPath) {
        
        var relation = workout.relationForKey("whoCompleted")
        var query = relation.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                for object in objects {
                    if object.username == self.currentUser.username {
                        self.addCompletedImage(indexPath)
                    }
                }
                
            } else {
                println(error)
            }
            
        }
        
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return weekArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : GymWorkoutsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GymWorkoutsCell", forIndexPath: indexPath) as GymWorkoutsTableViewCell
        // Reset cell to default
        cell.completedImageView.image = nil
        cell.workoutCompleted = false

        var array = weekArray[indexPath.section]
        var workout = array[indexPath.row] as GymWorkouts
        
        self.checkForCompletion(workout, indexPath: indexPath)
        
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
    
    func addCompletedImage(indexPath: NSIndexPath) {
        var cell : GymWorkoutsTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as GymWorkoutsTableViewCell
        cell.completedImageView.image = UIImage(named: "completedIcon")
        cell.workoutCompleted = true
    }
    
    func workoutAlert(gesture : UITapGestureRecognizer) {
        
        var location = gesture.locationInView(self.tableView)
        var indexPath = self.tableView.indexPathForRowAtPoint(location)
        
        
        var completeAlert = SCLAlertView()
        completeAlert.addButton("Hell Yeah", actionBlock: { () -> Void in
            self.completeWorkout(indexPath!)
        })
        completeAlert.showCustom(self, image: UIImage(named: "completedIcon"), color: UIColor(red: 56.0/255.0, green: 142.0/255.0, blue: 60.0/255.0, alpha: 1), title: "Workout Completed", subTitle: "Did you complete this workout?", closeButtonTitle: "Nope", duration: 0)
        
    }
    
    func completeWorkout(indexPath: NSIndexPath) {
        var cell : GymWorkoutsTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as GymWorkoutsTableViewCell
        if (!cell.workoutCompleted) {
            self.addCompletedImage(indexPath)
            // add OC points to current user and save
            currentUser.gymPoints += 15
            currentUser.saveInBackgroundWithTarget(nil, selector: nil)
            // get current workout and add relation to currentuser
            var array = weekArray[indexPath.section]
            var workout = array[indexPath.row] as GymWorkouts
            var relation = workout.relationForKey("whoCompleted")
            relation.addObject(currentUser)
            workout.saveInBackgroundWithTarget(nil, selector: nil)
            self.setUpPointsLabel()
        }
        else {
            var errorAlert = SCLAlertView()
            errorAlert.showError(self, title: "Already Completed", subTitle: "You can't complete the same workout twice", closeButtonTitle: "Ok", duration: 0)
        }
    }

}
