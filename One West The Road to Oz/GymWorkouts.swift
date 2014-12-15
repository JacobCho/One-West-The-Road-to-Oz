//
//  GymWorkouts.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-04.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import Foundation
import Parse

class GymWorkouts : PFObject, PFSubclassing {
    
    class func parseClassName() -> String! {
        return "gymWorkouts"
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    @NSManaged var workout : String
    @NSManaged var reps : String
    @NSManaged var weekStarting : NSDate
    @NSManaged var day : String
    @NSManaged var whoCompleted : PFRelation?

}
