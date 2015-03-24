//
//  Stocking.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Stocking: PFObject, PFSubclassing {

	@NSManaged var brewery: Brewery
	@NSManaged var vendor: Vendor
    
    // MARK: - PFSubclassing
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Stocking"
    }
}