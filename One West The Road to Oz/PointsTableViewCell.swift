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
    @IBOutlet weak var pointsLabel: UILabel!
    var pointsBar = UIView()
    var pointsLeaderMaxBarWidth : CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userProfileImageView.layer.cornerRadius = 17
        self.userProfileImageView.clipsToBounds = true
        pointsLeaderMaxBarWidth = UIScreen.mainScreen().bounds.size.width * 0.60
        self.setUpPointsBar()
    }
    
    func setUpPointsBar() {
        self.pointsBar.frame = CGRect(x: 60, y: 15, width: 0, height: 25)
        self.addSubview(pointsBar)
    }
    
    func animatePointsBar(indexPath: NSIndexPath, barWidth: CGFloat) {
        setupPointsBarColour(indexPath)
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
    
    func setupPointsBarColour(indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.pointsBar.backgroundColor = Constants.flatRed
        case 1:
            self.pointsBar.backgroundColor = Constants.flatBlue
        case 2:
            self.pointsBar.backgroundColor = Constants.flatGreen
        case 3:
            self.pointsBar.backgroundColor = Constants.flatOrange
        case 4:
            self.pointsBar.backgroundColor = Constants.flatPurple
        default:
            self.pointsBar.backgroundColor = Constants.flatRed

        }
    }
    
    func setupPointsLabel(paddlerPoints: Int) {
        self.pointsLabel.text = String(paddlerPoints) + "pts"
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.pointsLabel.alpha = 1.0
        })
    }
}
