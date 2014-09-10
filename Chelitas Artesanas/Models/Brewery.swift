//
//  Brewery.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Brewery {
    var name = ""
    var websiteURLPath = ""
    var vendors = RLMArray(objectClassName: Vendor.className())
    
    var websiteURL: NSURL {
        get {
            return NSURL(string: websiteURLPath)
        }
        set(URL) {
            if let URLPath = URL.path {
                websiteURLPath = URLPath
            } else {
                websiteURLPath = ""
            }
        }
    }
}