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
    
    var currentUser : User = User.currentUser()

    @IBOutlet weak var tableView: UITableView!
    var paddlersArray : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fillPaddlersArray()
        self.setupPieChart()
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
        cell.setupPointsLabel(Int(paddler.getTotalPoints()))
        return cell
        
    }
    
    // MARK: Table View Delegate 
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
    
    // MARK: Helper Methods
    
    func setupPieChart() {
        var pieChartItemOC : PNPieChartDataItem = PNPieChartDataItem(value: CGFloat(currentUser.ocPoints), color: Constants.flatBlue, description: "OC Points: \(currentUser.ocPoints)")
        var pieChartItemGym : PNPieChartDataItem = PNPieChartDataItem(value: CGFloat(currentUser.gymPoints), color: Constants.flatGreen, description: "Gym Points: \(currentUser.gymPoints)")
        
        var items : NSArray = [pieChartItemOC, pieChartItemGym]
        
        var pieChart : PNPieChart = PNPieChart(frame: CGRectMake(self.view.frame.width/2 - 100, self.view.frame.height/2, 200, 200), items: items)
        pieChart.descriptionTextColor = UIColor.whiteColor()
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14.0)
        pieChart.strokeChart()
        
        self.view.addSubview(pieChart)
    }

}
