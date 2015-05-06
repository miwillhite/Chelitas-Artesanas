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
    @NSManaged var phone: String?
    @NSManaged var location: PFGeoPoint
    
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
    
    // FIXME: Remove this
    var stockings: [Stocking] {
        get {
            return [Stocking]()
        }
    }
    
    /// Fetches stocked breweries and "renders" the results
    /// The callback is called on a background thread
    func stockedBreweries(render: [Brewery] -> Void) {
        let query = Stocking.queryWithPredicate(NSPredicate(format: "vendor = %@", self))
        
        var breweries = [Brewery]()
        query?.findObjectsInBackgroundWithBlock({ (results, error) in
            if let results = results {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    for result in results {
                        let stocking = result as! Stocking
                        if breweries.filter({ $0.objectId == stocking.brewery.objectId }).count == 0 {
                            stocking.brewery.fetchIfNeeded()
                            breweries.append(stocking.brewery)
                        }
                    }
                    render(breweries)
                })
            }
        })
    }
}