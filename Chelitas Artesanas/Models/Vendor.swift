//
//  Vendor.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/9/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Vendor: RLMObject {
    dynamic var id              = ""
    dynamic var title           = ""
    dynamic var lat: Double     = 0.0
    dynamic var lon: Double     = 0.0
    dynamic var stockings       = RLMArray(objectClassName: Stocking.className())
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["breweriesAsArray"]
    }
    
    // MARK: - Ignored Properties

    var breweriesAsArray: [Brewery] {
        get {
            var breweries = [Brewery]()
            for stocking in self.stockings {
                if let stocking = stocking as? Stocking {
                    breweries.append(stocking.brewery)
                }
            }
            return breweries
        }
    }
}