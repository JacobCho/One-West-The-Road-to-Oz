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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImage()
    }
    
    func setupProfileImage() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
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
        
        cell.navLabel.text = navItem
        
        return cell

    }
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
