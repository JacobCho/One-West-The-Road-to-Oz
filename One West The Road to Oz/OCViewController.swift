//
//  OCViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse


class OCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    let currentUser = User.currentUser()
    
    var workoutsArray = [OCWorkouts]()
    var thisWeek : OCWorkouts?

    @IBOutlet weak var weekStartingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "workoutAlert:")
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(tapGesture)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        queryForWorkouts()
        setupPointsLabel()
    }
    
    func queryForWorkouts() {
        self.workoutsArray.removeAll()
        var query = OCWorkouts.query()
        query.whereKey("weekStarting", lessThan: Constants.todaysDate)
        query.whereKey("weekStarting", greaterThan: Constants.lastWeek)
        query.orderByAscending("day")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                for object in objects {
                    self.workoutsArray.append(object as OCWorkouts)
                }
                self.thisWeek = objects[0] as? OCWorkouts
                var thisWeek = self.setWeekFromDate(self.thisWeek!.weekStarting)
                self.weekStartingLabel.text = "Week Starting: " + thisWeek
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func setupPointsLabel() {
        self.pointsLabel.text = "Points: " + String(currentUser.ocPoints)
    }
    
    func checkForCompletion(workout : OCWorkouts, indexPath : NSIndexPath) {

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workoutsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : WorkoutsTableViewCell = tableView.dequeueReusableCellWithIdentifier("OCWorkoutCell", forIndexPath: indexPath) as WorkoutsTableViewCell
        
        var workout = workoutsArray[indexPath.row]
        self.checkForCompletion(workout, indexPath: indexPath)
        
        cell.dayLabel.text = workout.day + ":"
        cell.workoutLabel.text = workout.workout
        
        return cell
        
    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, DidSelectRowAtIndexPath indexPath: NSIndexPath) {
       println("Row Selected")
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // Mark: Helper Methods
    func setWeekFromDate(thisWeek : NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.stringFromDate(thisWeek.dateByAddingTimeInterval(60*60*24*1))
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
        var cell : WorkoutsTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as WorkoutsTableViewCell
        if (!cell.workoutCompleted) {
            self.addCompletedImage(indexPath)
            // add OC points to current user and save
            currentUser.ocPoints += 100
            currentUser.saveInBackgroundWithTarget(nil, selector: nil)
            // get current workout and add relation to currentuser
            var workout = workoutsArray[indexPath.row]
            var relation = workout.relationForKey("whoCompleted")
            relation.addObject(currentUser)
            workout.saveInBackgroundWithTarget(nil, selector: nil)
        }
        else {
            var errorAlert = SCLAlertView()
            errorAlert.showError(self, title: "Already Completed", subTitle: "You can't complete the same workout twice", closeButtonTitle: "Ok", duration: 0)
        }
    }
    
    func addCompletedImage(indexPath: NSIndexPath) {
        var cell : WorkoutsTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as WorkoutsTableViewCell
        cell.completedImageView.image = UIImage(named: "completedIcon")
        cell.workoutCompleted = true
    }

}
