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
    @IBOutlet weak var pointsBar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userProfileImageView.layer.cornerRadius = 17
        self.userProfileImageView.clipsToBounds = true
    }
}
