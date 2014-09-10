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
    var lastUpdated = NSDate()
    var brewery = Brewery()
    var vendor = Vendor()
}