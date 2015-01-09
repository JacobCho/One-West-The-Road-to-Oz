//
//  PointsTableViewCell.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2015-01-07.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import Parse

class PointsTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImageView: PFImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var pointsBar = UIView()
    var pointsLeaderMaxBarWidth : CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userProfileImageView.layer.cornerRadius = 17
        self.userProfileImageView.clipsToBounds = true
        pointsLeaderMaxBarWidth = self.frame.width - 100
        self.setUpPointsBar()
    }
    
    func setUpPointsBar() {
        
        
        self.pointsBar.frame = CGRect(x: 60, y: 15, width: 0, height: 25)
        self.pointsBar.backgroundColor = Constants.flatRed
        self.addSubview(pointsBar)
    }
    
    func animatePointsBar(indexPath: NSIndexPath, barWidth: CGFloat) {
        if indexPath.row == 0 {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.pointsBar.frame = CGRect(x: 60, y: 15, width: self.pointsLeaderMaxBarWidth!, height: 25)
            })
        } else {
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.pointsBar.frame = CGRect(x: 60, y: 15, width: barWidth, height: 25)
            })
        }
    }
    
}
