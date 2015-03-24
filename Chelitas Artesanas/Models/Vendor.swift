//
//  Vendor.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/9/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Vendor: PFObject, PFSubclassing, MapItemProviderProtocol {

    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var location: PFGeoPoint
    @NSManaged var stockings: [Stocking]
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Vendor"
    }
    
    
    // Required to conform to the MapItemProviderProtocol
    var title: String {
        get {
            return name
        }
    }
    
    var lat: Double {
        get {
            return location.latitude
        }
    }
    
    var lon: Double {
        get {
            return location.longitude
        }
    }
    
    var stockedBreweries: [Brewery] {
        get {
            var breweries = NSMutableSet()
            for stocking in self.stockings {
                if let brewery = stocking.brewery {
                    breweries.addObject(brewery)
                }
            }
            return breweries.allObjects as! [Brewery]
        }
    }
}