//
//  User.swift
//  One West The Road to Oz
//
//  Created by Jacob Cho on 2014-12-01.
//  Copyright (c) 2014 Jacob. All rights reserved.
//

import Foundation
import Parse

class User: PFUser, PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    @NSManaged var gymPoints : Int
    @NSManaged var ocPoints : Int
    @NSManaged var practicePoints : Int
    @NSManaged var profileImage: PFFile?

    func getTotalPoints() -> Double {
        
        return Double(self.gymPoints) + Double(self.ocPoints)
    }
    
}
