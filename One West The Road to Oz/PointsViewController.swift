//
//  PointsViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit
import Parse

class PointsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var paddlersArray : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fillPaddlersArray()
    }

    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paddlersArray.count > 5 {
            return 5
        } else {
        return paddlersArray.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : PointsTableViewCell = tableView.dequeueReusableCellWithIdentifier("PointsCell", forIndexPath: indexPath) as PointsTableViewCell
        var paddler = paddlersArray[indexPath.row]
        cell.userNameLabel!.text = paddler.username
        
        if let profileImage = paddler.profileImage {
            cell.userProfileImageView.file = profileImage
            cell.userProfileImageView.loadInBackground(nil)
            
        }
        
        let percentFromLeader : Double = paddler.getTotalPoints()/self.paddlersArray[0].getTotalPoints()
        let barWidth : CGFloat = CGFloat(percentFromLeader) * CGFloat(cell.pointsLeaderMaxBarWidth!)
        
        cell.animatePointsBar(indexPath, barWidth: barWidth)
        
        return cell
        
    }
    
    // MARK: Parse Methods
    func fillPaddlersArray() {
        var query = User.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
            self.paddlersArray = objects as [User]!
            self.paddlersArray.sort({ $0.getTotalPoints() > $1.getTotalPoints() })
            self.tableView.reloadData()
            }
            else {
                println(error)
            }
        }
    }

}
