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
        return paddlersArray.count
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
        let pointsLeaderMaxBarWidth = cell.frame.width - 100
        var pointsBar = UIView()
        pointsBar.frame = CGRect(x: 60, y: 15, width: 0, height: 25)
        pointsBar.backgroundColor = Constants.flatRed
        cell.addSubview(pointsBar)
        
        if indexPath.row == 0 {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                pointsBar.frame = CGRect(x: 60, y: 15, width: pointsLeaderMaxBarWidth, height: 25)
            })
        } else {
            let percentFromLeader : Double = paddler.getTotalPoints()/self.paddlersArray[0].getTotalPoints()
            let barWidth : CGFloat = CGFloat(percentFromLeader) * CGFloat(pointsLeaderMaxBarWidth)
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                pointsBar.frame = CGRect(x: 60, y: 15, width: barWidth, height: 25)
            })
        }
        
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
