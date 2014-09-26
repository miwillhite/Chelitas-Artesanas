//
//  Brewery.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Brewery: RLMObject {
    dynamic var id          = ""
    dynamic var name        = ""
    dynamic var stockings   = RLMArray(objectClassName: Stocking.className())
    
    dynamic private var websiteURLPath = ""
    dynamic var websiteURL: NSURL {
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
    
    override class func primaryKey() -> String! {
        return "id"
    }
}