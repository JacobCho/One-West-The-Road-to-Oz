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
    
    var workoutsArray = [OCWorkouts]()
    var thisWeek : OCWorkouts?

    @IBOutlet weak var weekStartingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
    }
    
    func queryForWorkouts() {
        let todaysDate = NSDate(timeIntervalSinceNow: 0)
        let nextWeek = NSDate(timeInterval: 604800, sinceDate: todaysDate)
        let lastWeek = NSDate(timeInterval: -604800, sinceDate: todaysDate)
        self.workoutsArray.removeAll()
        var query = OCWorkouts.query()
        query.whereKey("weekStarting", lessThan: todaysDate)
        query.whereKey("weekStarting", greaterThan: lastWeek)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        completeAlert.showSuccess(self, title: "Workout Completed", subTitle: "Did you complete this workout?", closeButtonTitle: "Ok", duration: 0)
        
    }
    
    func completeWorkout(indexPath: NSIndexPath) {
        var cell : WorkoutsTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as WorkoutsTableViewCell
        cell.completedImageView.image = UIImage(named: "completedIcon")
    }

}
