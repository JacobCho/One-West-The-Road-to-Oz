//
//  GymWorkoutsTableViewCell.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-18.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import UIKit

class GymWorkoutsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var completedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSizeMake(0, 5.0)
    }

}
