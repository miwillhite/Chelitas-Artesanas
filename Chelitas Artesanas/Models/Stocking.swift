//
//  Stocking.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Stocking: RLMObject {
    dynamic var id              = ""
    dynamic var lastUpdated     = NSDate()
    dynamic var brewery         = Brewery()
    dynamic var vendor          = Vendor()
    
    override class func primaryKey() -> String! {
        return "id"
    }
}