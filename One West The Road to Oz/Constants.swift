//
//  Constants.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-10.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
   static let flatRed = UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1)
   static let weekInSecs : NSTimeInterval = 604800
   static let todaysDate = NSDate(timeIntervalSinceNow: 0)
   static let nextWeek = NSDate(timeInterval: weekInSecs, sinceDate: todaysDate)
   static let lastWeek = NSDate(timeInterval: -weekInSecs, sinceDate: todaysDate)
    
}

