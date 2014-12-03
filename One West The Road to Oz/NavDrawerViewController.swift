//
//  NavDrawerViewController.swift
//  
//
//  Created by Jacob Cho on 2014-12-01.
//
//

import UIKit

class NavDrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var navArray : Array<String> = ["Workouts", "Information", "TT Results", "Settings"]
    var iconArray :Array<UIImage>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
        setupIcons()
    }
    
    func setupProfileImage() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/4
        self.profileImageView.clipsToBounds = true
    }
    
    func setupIcons() {
        
        var workoutIcon : UIImage = UIImage(named: "WorkoutIcon")!
        iconArray = [workoutIcon, workoutIcon, workoutIcon, workoutIcon]
        
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return navArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : NavDrawerTableCell = tableView.dequeueReusableCellWithIdentifier("navDrawerCell", forIndexPath: indexPath) as NavDrawerTableCell
        
        let navItem = navArray[indexPath.row]
        let icon = UIImage(named:"WorkoutIcon")
        cell.navLabel.text = navItem
        cell.iconImageView.image = icon
        
        return cell

    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
