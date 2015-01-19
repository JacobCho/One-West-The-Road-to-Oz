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

    var pieChart : PNPieChart?

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
        let pieChartItemOC : PNPieChartDataItem = PNPieChartDataItem(value: CGFloat(currentUser.ocPoints), color: Constants.flatBlue, description: "OC1: \(currentUser.ocPoints)")
        let pieChartItemGym : PNPieChartDataItem = PNPieChartDataItem(value: CGFloat(currentUser.gymPoints), color: Constants.flatGreen, description: "Gym: \(currentUser.gymPoints)")
        
        let items : NSArray = [pieChartItemOC, pieChartItemGym]
        
        
        
        if let chart = self.pieChart {
            chart.removeFromSuperview()
            
            self.drawPieChart(items)
            
        } else {
        
            self.drawPieChart(items)
            

        }

    }
    
    
    func drawPieChart(items: NSArray) {
        var height : CGFloat = self.view.frame.height - self.tableView.frame.height - 80
        var width : CGFloat = height
        var xPos = ((self.view.frame.width/2) - (height/2))
        var yPos = self.tableView.frame.height + 20
        
        if self.view.frame.height > 600 {
            height = self.view.frame.height - self.tableView.frame.height - 150
            width = height
            xPos = ((self.view.frame.width/2) - (height/2))
            yPos = self.tableView.frame.height + 50
        }
        
        self.pieChart = PNPieChart(frame: CGRectMake(xPos, yPos, width, height), items: items)
        self.pieChart!.descriptionTextColor = UIColor.whiteColor()
        self.pieChart!.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14.0)
        self.pieChart!.strokeChart()
        
        self.view.addSubview(self.pieChart!)
        
        
        
        
    }

}
