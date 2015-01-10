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
   static let flatBlue = UIColor(red: 30.0/255.0, green: 136.0/255.0, blue: 229/0/255.0, alpha: 1)
   static let flatGreen = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1)
   static let flatOrange = UIColor(red: 245.0/255.0, green: 124.0/255.0, blue: 0, alpha: 1)
   static let flatPurple = UIColor(red: 156.0/255.0, green: 39.0/255.0, blue: 176.0/255.0, alpha: 1)
    
   static let darkGreyFont = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
    
   static let weekInSecs : NSTimeInterval = 604800
   static let todaysDate = NSDate(timeIntervalSinceNow: 0)
   static let nextWeek = NSDate(timeInterval: weekInSecs, sinceDate: todaysDate)
   static let lastWeek = NSDate(timeInterval: -weekInSecs, sinceDate: todaysDate)
    
    
}

class Global {
    class func setWeekFromDate(thisWeek : NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.stringFromDate(thisWeek.dateByAddingTimeInterval(60*60*24*1))
    }
}

