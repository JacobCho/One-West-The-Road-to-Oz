//
//  GymViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse

class GymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let currentUser = User.currentUser()
    var day1Array : [GymWorkouts]?
    var day2Array : [GymWorkouts]?
    var day3Array : [GymWorkouts]?
    var weekArray : [NSArray] = []
    var refreshControl : UIRefreshControl!
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
        self.fillPickerArray()
        
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.tabBarController!.tabBar.frame.height, 0.0)
        
        if selectedWeek == nil {
            self.queryForLastWorkoutDate()
            self.day1Array = []
            self.day2Array = []
            self.day3Array = []
        }
        
        // Refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshing:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        var tapGesture = UITapGestureRecognizer(target: self, action: "workoutAlert:")
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(tapGesture)    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    

    @IBAction func weekStartingButtonPressed(sender: UIButton) {
        var datePickerAlert = UIAlertController(title: "Pick a date", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .ActionSheet)
        var pickerFrame = CGRectMake(17, 52, datePickerAlert.view.bounds.width - 50, 100)
        var picker : UIPickerView = UIPickerView(frame: pickerFrame)
        
        picker.delegate = self
        picker.dataSource = self
        
        picker.showsSelectionIndicator = true
        picker.selectRow(0, inComponent: 0, animated: false)
        
        datePickerAlert.view.addSubview(picker)
        
        let selectAction = UIAlertAction(title: "Select", style: .Default) { (action: UIAlertAction!) -> Void in
            var row = picker.selectedRowInComponent(0)
            self.selectedWeek = self.pickerArray[row]
            self.queryForWorkouts(self.selectedWeek!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        datePickerAlert.addAction(selectAction)
        datePickerAlert.addAction(cancelAction)
        datePickerAlert.view.tintColor = Constants.flatRed
        self.presentViewController(datePickerAlert, animated: true, completion: nil)
        
    }
    
    // MARK: Parse Helper Methods
    
    func fillPickerArray() {
        var query = GymWorkouts.query()
        query.orderByDescending("weekStarting")
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
        self.clearAllArrays()
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
                if self.day1Array!.count != 0 {
                self.weekArray.append(self.day1Array!)
                }
                if self.day2Array!.count != 0 {
                self.weekArray.append(self.day2Array!)
                }
                if self.day3Array!.count != 0 {
                self.weekArray.append(self.day3Array!)
                }
    
                var thisWeek = Global.setWeekFromDate(weekStarting)
                self.configureWeekStartingButton(thisWeek)
                self.tableView.reloadData()
            }
            else {
                println(error)
            }
            
        }
        if (self.refreshControl != nil) {
            self.refreshControl.endRefreshing()
        }
        
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
        
        return self.weekArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return weekArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : GymWorkoutsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GymWorkoutsCell", forIndexPath: indexPath) as GymWorkoutsTableViewCell
        // Reset cell to default
        cell.completedImageView.image = nil
        cell.workoutCompleted = false
        if weekArray.count != 0 {
            var array = weekArray[indexPath.section]
            var workout = array[indexPath.row] as GymWorkouts
            
            self.checkForCompletion(workout, indexPath: indexPath)
            
            cell.workoutLabel.text = workout.workout
            cell.repsLabel.text = "Reps: " + workout.reps
            
        }
        
        return cell
        
    }

    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, DidSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row Selected")
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Setup section header view
        let sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 40))
        sectionHeaderView.backgroundColor = UIColor.whiteColor()
        sectionHeaderView.alpha = 0.9
        // Setup section header label
        let sectionHeaderLabel = UILabel(frame: CGRectMake(55, 0, 100, sectionHeaderView.frame.height))
        sectionHeaderLabel.font = UIFont.boldSystemFontOfSize(15)
        sectionHeaderLabel.textColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
        // Setup section header image
        let sectionHeaderImage = UIImageView(frame: CGRectMake(20, 5, 30, 30))
        
        switch section {
            
          case 0:
            sectionHeaderImage.image = UIImage(named: "bicepIcon")
          case 1:
            sectionHeaderImage.image = UIImage(named: "barbellIcon")
          case 2:
            sectionHeaderImage.image = UIImage(named: "saiyanIcon")
          default:
            sectionHeaderImage.image = UIImage(named: "bicepIcon")
        }
        
        
        sectionHeaderView.addSubview(sectionHeaderImage)
        sectionHeaderView.addSubview(sectionHeaderLabel)
        
        sectionHeaderLabel.text = "Day " + String(section + 1)
        
        return sectionHeaderView
    }

    // MARK: Helper Methods
    func clearAllArrays() {
        self.workoutsArray.removeAll()
        self.weekArray.removeAll()
        self.day1Array!.removeAll()
        self.day2Array!.removeAll()
        self.day3Array!.removeAll()

    }
    func setUpPointsLabel() {
        self.pointsLabel.text = "Points: " + String(self.currentUser.gymPoints)
        println(self.currentUser.gymPoints)
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
    
    func refreshing(sender: AnyObject) {
        if (self.selectedWeek == nil) {
            self.queryForWorkouts(self.thisWeek!.weekStarting)
        } else {
            self.queryForWorkouts(self.selectedWeek!)
        }
        
        sender as UIRefreshControl
        
        sender.endRefreshing()
    }
    
    // MARK : UIPickerDataSource Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return Global.setWeekFromDate(pickerArray[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
