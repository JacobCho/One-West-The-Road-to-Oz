//
//  InfoViewController.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2015-01-19.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import UIKit
import Parse

class InfoViewController: UIViewController {
    
    @IBOutlet weak var trainingButton: UIButton!
    @IBOutlet weak var racesButton: UIButton!
    @IBOutlet weak var generalButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setShadows()
        
    }
    
    func setShadows() {
        self.trainingButton.layer.shadowOpacity = 0.5
        self.trainingButton.layer.shadowOffset = CGSizeMake(0, 5.0)
        
        self.racesButton.layer.shadowOpacity = 0.5
        self.racesButton.layer.shadowOffset = CGSizeMake(0, 5.0)
        
        self.generalButton.layer.shadowOpacity = 0.5
        self.generalButton.layer.shadowOffset = CGSizeMake(0, 5.0)
        
    }
    

}
