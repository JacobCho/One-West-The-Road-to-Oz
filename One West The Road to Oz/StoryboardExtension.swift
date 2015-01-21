//
//  StoryboardExtension.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2015-01-20.
//  Copyright (c) 2015 Jacob. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func navDrawerViewController() -> NavDrawerViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("NavDrawerViewController") as? NavDrawerViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
    }
    
    class func workoutsTabBarController() -> UIViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("WorkoutsTabBarController") as UIViewController
    }
    
    class func infoViewController() -> UIViewController {
        return mainStoryboard().instantiateViewControllerWithIdentifier("InfoViewController") as UIViewController
    }
    
}